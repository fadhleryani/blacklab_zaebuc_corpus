compile_backend:
	@echo "Compiling backend..."
	@cd src/BlackLab && mvn clean install

compile_frontend:
	@echo "Compiling frontend..."
	@cd src/corpus-frontend && mvn clean install

delete_webapps:
	@echo "Deleting webapps..."
	@sudo rm -fr /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-server*
	@sudo rm -fr /opt/homebrew/opt/tomcat@9/libexec/webapps/corpus-frontend*

setup_latest: delete_webapps
	@echo "Setting up latest..."	
	@sudo cp src/BlackLab/server/target/blacklab-server*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-server.war
	@sudo cp src/corpus-frontend/target/corpus-frontend*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/corpus-frontend.war

update_config:
	@echo "Updating config..."
	@sudo cp -pr blacklab_configs/ ~/.blacklab/
	@rm -fr data/blacklab-corpora/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/blacklab-corpora/zaebuc-written data/zaebuc_written.xml zaebuc-input-format
	@brew services restart tomcat@9
