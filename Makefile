.PHONY: set_config_paths configure-frontend-properties configure-server-yaml drop default sample 
.DEFAULT_GOAL := default
include *.env

default: compile set_config_paths reindex update_config_dev

sample: compile set_config_paths reindex_sample update_config_dev

drop: compile set_config_paths reindex prep_tomcat_docker 

sample_drop: compile set_config_paths reindex_sample prep_tomcat_docker 

run_drop:
	@cd src/docker_droplet_tomcat
	@docker compose up --build -d


run_drop_remote: rsync
	@ssh $(USERatIP) -t 'cd /app && docker compose up --build -d'




ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
PROJECT_CONFIGS_DIR := $(ROOT_DIR)data/index-configs/projectconfigs
ZAEBUC_INDEX_DIR := $(ROOT_DIR)data/index/zaebuc-written
	

set_config_paths: configure-frontend-properties configure-server-yaml

configure-frontend-properties:
	@sed -i.bak  "s|corporaInterfaceDataDir=.*|corporaInterfaceDataDir=$(PROJECT_CONFIGS_DIR)|" \
        "$(ROOT_DIR)data/index-configs/blacklab-frontend.properties"
	@echo "Updated blacklab-frontend.properties with corporaInterfaceDataDir=$(PROJECT_CONFIGS_DIR)"

configure-server-yaml:
	@sed -i.bak  "s|indexLocations:.*|indexLocations\:\n- $(ZAEBUC_INDEX_DIR)|" \
        "$(ROOT_DIR)data/index-configs/blacklab-server.yaml"
	@echo "Updated blacklab-server.yaml with indexLocations: $(ZAEBUC_INDEX_DIR)"


compile: compile_backend compile_frontend
compile_backend:
	@echo "Compiling backend..."
	@cd src/BlackLab && mvn clean install

compile_frontend:
	@echo "Compiling frontend..."
	@cd src/blacklab-frontend && mvn clean install

delete_webapps:
	@echo "Deleting webapps..."
	@sudo rm -fr /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-server*
	@sudo rm -fr /opt/homebrew/opt/tomcat@9/libexec/webapps/*-frontend*

setup_dev: delete_webapps
	@echo "Setting up from bleeding edge, after locally compiling..."	
	@sudo cp src/BlackLab/server/target/blacklab-server*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-server.war

	@sudo cp src/blacklab-frontend/target/*-frontend*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-frontend.war



update_config_dev_soft: 
	@echo "Updating config without restarting..."
	@sudo rm -fr ~/.blacklab
	@sudo rm -fr /etc/blacklab
	@sudo cp -pr data/index-configs/ ~/.blacklab/
# 	@sudo cp -pr data/index-configs/ /etc/blacklab/
	

update_config_dev: setup_dev
	@echo "Updating config..."
	@sudo rm -fr ~/.blacklab
	@sudo rm -fr /etc/blacklab
	@sudo cp -pr data/index-configs/ ~/.blacklab/
# 	@sudo cp -pr data/index-configs/ /etc/blacklab/
	@brew services restart tomcat@9


reindex:
	@echo "reindexing corpus..."
	@rm -fr data/index/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written.xml zaebuc-input-format
	@brew services restart tomcat@9

reindex_sample:
	@echo "reindexing corpus..."
	@rm -fr data/index/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written_sample.xml zaebuc-input-format
	@brew services restart tomcat@9


prep_docker:
	@echo "Updating docker droplet setup files..."
	@rm -fr src/docker_droplet/data/index-configs/projectconfigs
	@rm -fr src/docker_droplet/data/index-configs/formats	
	@cp -pr data/index-configs/projectconfigs src/docker_droplet/data/index-configs/
	@cp -pr data/index-configs/formats src/docker_droplet/data/index-configs/

	@rm -fr src/docker_droplet/data/index/zaebuc-written
	@cp -pr data/index/zaebuc-written src/docker_droplet/data/index/zaebuc-written

	@cp src/BlackLab/server/target/blacklab-server*.war src/docker_droplet/blacklab-server.war
	@cp src/blacklab-frontend/target/*-frontend*.war src/docker_droplet/blacklab-frontend.war

prep_tomcat_docker:
	@echo "Updating docker droplet setup files..."
	@rm -fr src/docker_droplet_tomcat/data/index-configs/projectconfigs
	@rm -fr src/docker_droplet_tomcat/data/index-configs/formats	
	@cp -pr data/index-configs/projectconfigs src/docker_droplet_tomcat/data/index-configs/
	@cp -pr data/index-configs/formats src/docker_droplet_tomcat/data/index-configs/

	@rm -fr src/docker_droplet_tomcat/data/index/zaebuc-written
	@cp -pr data/index/zaebuc-written src/docker_droplet_tomcat/data/index/zaebuc-written

	@cp src/BlackLab/server/target/blacklab-server*.war src/docker_droplet_tomcat/blacklab-server.war
	@cp src/blacklab-frontend/target/*-frontend*.war src/docker_droplet_tomcat/blacklab-frontend.war

rsync_droplet:
	@rsync -avz -e ssh \
	--exclude='.DS_Store' \
	src/docker_droplet_tomcat/ \
	$(USERatIP):/app/
# rsync_droplet:
# 	@rsync -avz -e ssh \
# 	--exclude='.DS_Store' \
# 	src/docker_droplet/ \
# 	$(USERatIP):/app/




