FROM tomcat:9.0.108-jre21-temurin-noble

# Create directories for BlackLab data and config
RUN mkdir -p /data /blacklab

# Copy WAR file(s) to Tomcat
COPY blacklab*.war /usr/local/tomcat/webapps/

# Copy your data directory (entire contents)
COPY data/ /data/

# Copy config files SPECIFICALLY
# COPY data/index-configs/blacklab-server.yaml /etc/blacklab/
COPY data/index-configs /etc/blacklab/
# COPY data/index-configs/formats/ /etc/blacklab/formats/

EXPOSE 8080

CMD ["catalina.sh", "run"]