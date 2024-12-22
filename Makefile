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

setup_custom: delete_webapps
	@echo "Setting up from bleeding edge, after locally compiling..."	
	@sudo cp src/BlackLab/server/target/blacklab-server*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-server.war
	@sudo cp src/corpus-frontend/target/corpus-frontend*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/corpus-frontend.war

setup_official: delete_webapps
	@echo "Setting up official release..."
	@sudo cp src/official_release/blacklab-server*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/blacklab-server.war
	@sudo cp src/official_release/corpus-frontend*.war /opt/homebrew/opt/tomcat@9/libexec/webapps/corpus-frontend.war
	

update_config_custom:
	@echo "Updating config..."
	@sudo rm -fr ~/.blacklab
	@sudo rm -fr /etc/blacklab
	@sudo cp -pr blacklab_configs/ ~/.blacklab/
	@rm -fr data/blacklab-corpora/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/blacklab-corpora/zaebuc-written data/zaebuc_written.xml zaebuc-input-format
	@brew services restart tomcat@9

update_config_official:
	@echo "Updating config..."
	@sudo rm -fr /etc/blacklab
	@sudo rm -fr /etc/blacklab
	@sudo cp -pr blacklab_configs/ /etc/blacklab/
	@rm -fr data/blacklab-corpora/zaebuc-written
	@java -cp src/official_release/blacklab-3.0.1.jar:lib nl.inl.blacklab.tools.IndexTool create data/blacklab-corpora/zaebuc-written data/zaebuc_written.xml zaebuc-input-format
	@brew services restart tomcat@9