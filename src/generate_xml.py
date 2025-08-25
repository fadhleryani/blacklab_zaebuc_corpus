import pandas as pd
from lxml import etree


def load_data(datadir):
    en = pd.read_csv(f'{datadir}corrected.analyzed_en.tsv',sep='\t',index_col=[0,2,1])
    ar = pd.read_csv(f'{datadir}corrected.analyzed_ar.tsv',sep='\t',index_col=[0,2,1])
    data = pd.concat([en,ar])
    data.columns = [x.lower() for x in data.columns]
    documents = pd.read_csv(f'{datadir}documents.tsv',sep='\t',index_col=[0])
    documents.columns = [x.lower() for x in documents.columns]
    return data,documents

if __name__ == "__main__":
    data,metadata = load_data('../../zaebuc_written/ZAEBUC-v2.0_release/')
    data.head()