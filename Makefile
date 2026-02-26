.PHONY: default sample reindex_dev reindex reindex_sample
.DEFAULT_GOAL := default

compile: compile_backend compile_frontend
compile_backend:
	@echo "Compiling backend..."
	@cd src/BlackLab && mvn clean install

compile_frontend:
	@echo "Compiling frontend..."
	@cd src/blacklab-frontend && mvn clean install

reindex_dev:
	@echo "reindexing corpus..."
	@rm -fr data/index/zaebuc-written
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
	@./index-corpus.sh data/index/zaebuc-written data/zaebuc_written.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
	@echo "indexed full corpus at data/index/zaebuc-written"

reindex_sample_dev:
	@echo "reindexing corpus..."
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
	@./index-corpus.sh data/index/zaebuc-written data/zaebuc_written_sample.xml data/index-configs/formats/zaebuc-input-format.blf.yaml	
	@echo "indexed sample corpus at data/index/zaebuc-written"


reindex:
	@echo "reindexing corpus..."
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
	@cd data/index-configs/formats/ && java -cp ../../../src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create ../../index/zaebuc-written ../../zaebuc_written.xml zaebuc-input-format
	@echo "indexed sample corpus at data/index/zaebuc-written"

reindex_sample:
	@echo "reindexing corpus..."
	@rm -r data/index/zaebuc-written
	@mkdir -p data/index/zaebuc-written
	@cd data/index-configs/formats/ && java -cp ../../../src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create ../../index/zaebuc-written ../../zaebuc_written_sample.xml zaebuc-input-format
	@echo "indexed sample corpus at data/index/zaebuc-written"