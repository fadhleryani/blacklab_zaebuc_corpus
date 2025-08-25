# blacklab_zaebuc_corpus

#might have to make sure tomcat is using jdk11, by checking tomcat@9/bin/catalina, e.g.
JAVA_HOME:-Users/f/.jenv/versions/openjdk64-11.0.18
or explicityly /opt/homebrew/Cellar/openjdk@11/11.0.23/libexec/openjdk.jdk/Contents/Home/




# compile WARs, index, and update configs, and prepare docker`droplet, run:
```
make sample # or just make for full dataset
```

or separately:

```
make compile_backend
make compile_frontend
make index_sample # or index for full dataset
make update_config_dev
make prep_tomcat_docker
```


# setup and run container

```
<!-- # make rsync ##  -->
cd /docker_droplet
docker compose up --build -d
```
#### corpus should be reachable at
- \<localhost or ip.address\>:8080/blacklab-frontend/zaebuc-written/search
