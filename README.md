# blacklab_zaebuc_corpus


## clone repo with BlackLab server (@ 265aaa7) & frontend (@ 94c45aa) submodules
`git clone --recurse-submodules https://github.com/fadhleryani/blacklab_zaebuc_corpus.git`

## compile backend & frontend:

`make compile`

## index corpus

`make reindex` (or `make reindex_sample` to index testing sample)

## run app

`docker compose up --build -d`

#### url:- localhost:8080/blacklab-frontend/zaebuc-written/search


-----------------------------

## to run dev version (rtl text direction not working!)

### index corpus using dev indexing script (index-corpus.sh)

`make reindex_dev` (or `make reindex_sample_dev` to index testing sample)

### run app

`cd docker && docker compose up -d`
