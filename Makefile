.PHONY: compile reindex reindex_sample
.DEFAULT_GOAL := default

compile: compile_backend compile_frontend
compile_backend:
	@echo "Compiling backend..."
	@cd src/BlackLab && mvn clean install

compile_frontend:
	@echo "Compiling frontend..."
	@cd src/blacklab-frontend && mvn clean install



reindex:
	@echo "reindexing corpus..."
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
# 	@./index-corpus-265aaa7.sh data/index/zaebuc-written data/zaebuc_written.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
# 	java command below requires format to be in home ~/.blacklab directory
	@cd data/index-configs/formats/ && java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written.xml zaebuc-input-format
	@echo "indexed full corpus at data/index/zaebuc-written"

reindex_sample:
	@echo "reindexing corpus..."
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
# 	@./index-corpus-265aaa7.sh data/index/zaebuc-written data/zaebuc_written_sample.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
# # 	java command below requires format to be in home ~/.blacklab directory
	@cd data/index-configs/formats/ && java -cp ../../../src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create ../../index/zaebuc-written ../../zaebuc_written_sample.xml zaebuc-input-format
	@echo "indexed sample corpus at data/index/zaebuc-written"

reindex_dev:
	@echo "reindexing corpus..."
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
	@./index-corpus-dev.sh data/index/zaebuc-written data/zaebuc_written.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
# 	java command below requires format to be in home ~/.blacklab directory
# 	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
	@echo "indexed full corpus at data/index/zaebuc-written"

reindex_dev_sample:
	@echo "reindexing corpus..."
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
	@./index-corpus-dev.sh data/index/zaebuc-written data/zaebuc_written_sample.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
# 	java command below requires format to be in home ~/.blacklab directory
# 	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written_sample.xml 
	@echo "indexed sample corpus at data/index/zaebuc-written"


