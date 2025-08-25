import re
import pandas as pd
from lxml import etree
import numpy as np

def load_data(datadir):
    en = pd.read_csv(f'{datadir}corrected.analyzed_en.tsv',sep='\t',index_col=[0,2,1])
    ar = pd.read_csv(f'{datadir}corrected.analyzed_ar.tsv',sep='\t',index_col=[0,2,1])
    data = pd.concat([en,ar])
    data.columns = [x.lower() for x in data.columns]
    documents = pd.read_csv(f'{datadir}documents.tsv',sep='\t',index_col=[0])
    documents.columns = [x.lower() for x in documents.columns]
    return data, documents


def write_xml(data, metadata, out_path="../data/zaebuc_written.xml", sample=None):
    if sample:
        metadata = metadata.sample(sample, random_state=321)
    data = data.sort_index()
    metadata = metadata.sort_index()
    namespaces = {'xml': 'http://www.w3.org/XML/1998/namespace'}
    corpus = etree.Element("corpus")

    # loop through docs
    for doc_id in metadata.index[:]:
        # for doc_id in ['ar-2021-X32635', 'ar-2021-X32635']:

        # doc metadata
        doc = metadata.loc[doc_id].to_frame().drop(
            'text').T.reset_index(names='idx')
        doc['textDirection'] = doc['language'].map(
            lambda x: 'rtl' if x == 'Arabic' else 'ltr')
        doc = doc.to_xml(root_name='corpus', row_name='doc', attr_cols=doc.columns.to_list(
        ), xml_declaration=False, index=False)
        doc = etree.fromstring(doc)

        linesidxs = data.loc[doc_id].index.get_level_values(
            0).drop_duplicates()

        # loop through lines "Line_Index" (think like sentences)
        for lineidx in linesidxs:
            line = etree.Element('sent')
            line.attrib['idx'] = str(int(lineidx))
            doc[0].append(line)

            words = data.loc[(doc_id, lineidx)][:]

            # loop through words
            for idx in words.index:

                # punct handled as separate tag
                if words.loc[idx, 'manual_pos'] == 'PUNCT':
                    word = etree.Element('punct')
                    word.attrib[f'{{{namespaces["xml"]}}}id'] = f'w.wx.{idx}'
                    word.text = words.loc[idx, 'word']
                    line.append(word)
                    continue
                else:
                    word = etree.Element('word')

                # set idx and xml:id attributes
                word.attrib['idx'] = str(idx)
                word.attrib[f'{{{namespaces["xml"]}}}id'] = f'w.wx.{idx}'

                # set english gloss as english lemma
                if 'en' in doc_id:
                    gloss_value = words.loc[idx,
                                            'manual_lemma'].replace('+', '')
                    gloss_element = etree.Element('gloss')
                    gloss_element.set('class', gloss_value)
                    word.append(gloss_element)

                # loop through analysis columns (extracted.analyzed sheet),
                #  set them as class attributes, except for word
                for analysisid in words.columns:
                    value = words.loc[idx, analysisid]
                    
                     # skip nans
                    if isinstance(value,list) and not value:
                        continue
                    elif isinstance(value,float) and pd.isna(value): 
                        continue

                    # words go under text tag: <word><text>asdfa</text></word>
                    if analysisid == 'word':
                        analysis = etree.Element('text')
                        analysis.text = value

                    # split gloss into gloss_search elements
                    elif analysisid == 'gloss_search':
                        for gloss in set(value):
                            gloss = gloss
                            gloss_element = etree.Element("gloss_search")
                            gloss_element.set('class', gloss)
                            word.append(gloss_element)
                            # continue

                    # set remaining columns
                    else:
                        analysis = etree.Element(analysisid)
                        analysis.attrib['class'] = value

                    word.append(analysis)

                line.append(word)

        corpus.append(doc[0])

    etree.indent(corpus, space="    ")
    tree = etree.ElementTree(corpus)
    tree.write(out_path, pretty_print=True,
               xml_declaration=True, encoding="utf-8")

if __name__ == "__main__":
    data,metadata = load_data('../../zaebuc_written/ZAEBUC-v2.0_release/')
    data.head()
    