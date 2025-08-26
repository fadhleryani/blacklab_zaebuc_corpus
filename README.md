# blacklab_zaebuc_corpus


## clone repo with BlackLab server/frontend submodules
`git clone --recurse-submodules https://github.com/fadhleryani/blacklab_zaebuc_corpus.git`

### or run this after cloning
`git submodule update --init --recursive`


## to run on the local tomcat, make sure to set paths on the following two files:

- data/index-configs/blacklab-frontend.properties:

 corporaInterfaceDataDir=[absolute path to data/index-configs/projectconfigs directory]

- data/index-configs/blacklab-server.yaml: 

set absolute path to data/index/zaebuc-written


### note on tomcat jdk
if things don't work might have to make sure tomcat is using jdk11, by checking tomcat@9/bin/catalina, 

e.g.
JAVA_HOME:-Users/f/.jenv/versions/openjdk64-11.0.18


or explicityly /opt/homebrew/Cellar/openjdk@11/11.0.23/libexec/openjdk.jdk/Contents/Home/



## compile and run:

- local tomcat:
    - `make sample` or just `make` for full dataset`

- on docker:
    - `make sample_drop` or just `make drop` for building docker containers, and `make run_drop`


#### url:- localhost:8080/blacklab-frontend/zaebuc-written/search
