.PHONY: default sample 
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
	@rm -fr data/index/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
	@echo "indexed full corpus at data/index/zaebuc-written"

reindex_sample:
	@echo "reindexing corpus..."
	@rm -fr data/index/zaebuc-written
	@java -cp src/BlackLab/core/target/blacklab-*.jar nl.inl.blacklab.tools.IndexTool create data/index/zaebuc-written data/zaebuc_written_sample.xml data/index-configs/formats/zaebuc-input-format.blf.yaml
	@echo "indexed sample corpus at data/index/zaebuc-written"



