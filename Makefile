.PHONY: configure-frontend-properties configure-server-yaml drop default sample 
.DEFAULT_GOAL := default

default: compile reindex 

sample: compile reindex_sample 

run:
	@docker compose up --build -d


ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
PROJECT_CONFIGS_DIR := $(ROOT_DIR)data/index-configs/projectconfigs
ZAEBUC_INDEX_DIR := $(ROOT_DIR)data/index/zaebuc-written
	

compile: compile_backend compile_frontend
compile_backend:
	@echo "Compiling backend..."
	@cd src/BlackLab && mvn clean install

compile_frontend:
	@echo "Compiling frontend..."
	@cd src/blacklab-frontend && mvn clean install

reindex:
	@echo "reindexing corpus..."
	@rm -fr data/index/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written.xml data/index-configs/formats/zaebuc-input-format.blf.yaml

reindex_sample:
	@echo "reindexing corpus..."
	@rm -fr data/index/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written_sample.xml data/index-configs/formats/zaebuc-input-format.blf.yaml


# prep_tomcat_docker:
# 	@echo "Updating docker droplet setup files..."
# 	@rm -fr src/docker_droplet_tomcat/data/index-configs/projectconfigs
# 	@rm -fr src/docker_droplet_tomcat/data/index-configs/formats	
# 	@cp -pr data/index-configs/projectconfigs src/docker_droplet_tomcat/data/index-configs/
# 	@cp -pr data/index-configs/formats src/docker_droplet_tomcat/data/index-configs/

# 	@rm -fr src/docker_droplet_tomcat/data/index/zaebuc-written
# 	@cp -pr data/index/zaebuc-written src/docker_droplet_tomcat/data/index/zaebuc-written

# 	@cp src/BlackLab/server/target/blacklab-server*.war src/docker_droplet_tomcat/blacklab-server.war
# 	@cp src/blacklab-frontend/target/*-frontend*.war src/docker_droplet_tomcat/blacklab-frontend.war





