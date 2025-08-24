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

setup_official: delete_webapps
	@echo "Setting up official release..."
	@sudo cp src/official_release/blacklab-server*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-server.war
	@sudo cp src/official_release/corpus-frontend*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/corpus-frontend.war
	
	

update_config_dev: setup_dev
	@echo "Updating config..."
	@sudo rm -fr ~/.blacklab
	@sudo rm -fr /etc/blacklab
	@sudo cp -pr blacklab_configs/ ~/.blacklab/
# 	@sudo cp -pr blacklab_configs/ /etc/blacklab/
	@brew services restart tomcat@9

reindex:
	@echo "reindexing corpus..."
	@rm -fr data/blacklab-corpora/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/blacklab-corpora/zaebuc-written data/zaebuc_written.xml zaebuc-input-format
	@brew services restart tomcat@9

update_config_official: setup_official
	@echo "Updating config..."
	@sudo rm -fr /etc/blacklab
	@sudo rm -fr ~/.blacklab
	@sudo cp -pr blacklab_configs/ /etc/blacklab/
	# @sudo cp -pr blacklab_configs/ ~/.blacklab/
	@rm -fr data/blacklab-corpora/zaebuc-written
	@java -cp src/official_release/blacklab-3.0.1.jar:lib nl.inl.blacklab.tools.IndexTool create data/blacklab-corpora/zaebuc-written data/zaebuc_written.xml zaebuc-input-format
	@brew services restart tomcat@9

prep_docker:
	@echo "Updating docker droplet setup files..."
	@rm -fr src/blacklab-frontend/docker_droplet/data/index-configs/projectconfigs
	@rm -fr src/blacklab-frontend/docker_droplet/data/index-configs/formats	
	@sudo cp -pr blacklab_configs/projectconfigs src/blacklab-frontend/docker_droplet/data/index-configs/
	@sudo cp -pr blacklab_configs/formats src/blacklab-frontend/docker_droplet/data/index-configs/

	@rm -fr src/blacklab-frontend/docker_droplet/data/index/zaebuc-written
	@sudo cp -pr data/blacklab-corpora/zaebuc-written src/blacklab-frontend/docker_droplet/data/index/zaebuc-written

	@sudo cp src/BlackLab/server/target/blacklab-server*.war src/blacklab-frontend/docker_droplet/blacklab-server.war
	@sudo cp src/blacklab-frontend/target/*-frontend*.war src/blacklab-frontend/docker_droplet/blacklab-frontend.war

rsync_droplet:
	@rsync -avz -e ssh \
	--exclude='.DS_Store' \
	src/blacklab-frontend/docker_droplet/ \
	USERatIP:/app/