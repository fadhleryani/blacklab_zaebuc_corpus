FROM tomcat:9.0.108-jre21-temurin-noble


# Copy compiled WAR file(s) to Tomcat, rename them to remove version to match configs
COPY src/BlackLab/server/target/*.war /usr/local/tomcat/webapps/blacklab-server.war
COPY src/blacklab-frontend/target/*-frontend*.war /usr/local/tomcat/webapps/blacklab-frontend.war

# Copy indexed corpus
COPY data/index /data/index

# Copy index configs
COPY data/index-configs /etc/blacklab/

EXPOSE 8080

CMD ["catalina.sh", "run"]