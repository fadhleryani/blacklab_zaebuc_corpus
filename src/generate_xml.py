import pandas as pd
from lxml import etree

from copy import deepcopy
import re
import re

from nltk.stem.wordnet import WordNetLemmatizer

Lem = WordNetLemmatizer()


def remove_plurals(glosses):
    no_plurals = set()
    for g in re.split(r';|,', glosses):
        g = g.strip()
        lemma = Lem.lemmatize(g)
        no_plurals.add(lemma)
    return ';'.join(no_plurals)



# def create_tei_header(title):
#     # create the header element
#     header_element = etree.Element("teiHeader")
#     # create the fileDesc element
#     fileDesc_element = etree.SubElement(header_element, "fileDesc")
#     # create the titleStmt element
#     titleStmt_element = etree.SubElement(fileDesc_element, "titleStmt")

#     #NOTE:TITLE
#     # create the title element    
#     title_element = etree.SubElement(titleStmt_element, "title")
#     # set the text of the title element
#     title_element.text = title

#     # create the publicationStmt element
#     publicationStmt_element = etree.SubElement(fileDesc_element, "publicationStmt")
#     # create the distributor element
#     distributor_element = etree.SubElement(publicationStmt_element, "distributor")
#     # set the text of the distributor element

#     #TODO:specify distributor and bibl
#     distributor_element.text = "Distributor?"
#     # create the sourceDesc element
#     sourceDesc_element = etree.SubElement(fileDesc_element, "sourceDesc")
#     # create the bibl element
#     bibl_element = etree.SubElement(sourceDesc_element, "bibl")
#     # set the text of the bibl element
#     bibl_element.text = "Bibl?"    
#     return header_element


def create_tei(dataframe,title):
    # create the root element
    # root_element = etree.Element("TEI", xmlns="http://www.tei-c.org/ns/1.0")
    root_element = etree.Element("corpus")
    
    # header_element = create_tei_header(title)
    # root_element.append(header_element)
    
    # create the text element
    # text_element = etree.SubElement(root_element, "text")

    # create the body element
    # body_element = etree.SubElement(text_element, "body")
    
    for docid in dataframe['Document'].unique():
        # create the p element
        doc_element = etree.SubElement(root_element, "doc")
        doc_element.set('idx', docid)
        doc_element.set('textDirection', 'ltr' if 'EN-' in docid else 'rtl')
        
        for lineid in dataframe.query('Document == @docid')['Line_Index'].unique():
            # create the s element
            s_element = etree.SubElement(doc_element, "sent")
            s_element.set('idx', str(int(lineid)))
            word_counter = 1
            for _word_idx, row in dataframe.query('Document == @docid and Line_Index == @lineid').reset_index().iterrows():
                if row['Auto_POS'] == 'PUNCT':
                    tok_element = etree.SubElement(s_element, "punc")                    
                    tok_element.text = row['Word']
                else:                                        
                    # create the w element
                    tok_element = etree.SubElement(s_element, "word")
                    
                    text_element = etree.SubElement(tok_element, "text")
                    # set the text of the w element
                    text_element.text = row['Word']
                    
                    # set the attributes of the w element ['Flag', 'Auto_Tokenization',
                    #  'Auto_POS', 'Auto_Lemma', 'Manual_Tokenization', 'Manual_POS',
                    #  'Manual_Lemma', 'Comment']
                    tags = [
                    'Flag',
                    'Auto_Tokenization',
                    'Auto_POS',
                    'Auto_Lemma',
                    'Manual_Tokenization',
                    'Manual_POS',
                    'Manual_Lemma',
                    'Comment',                                                                
                        ]
                    artags = ['Manual_Diacritized_Lemma',
                    'Gloss']
                    if 'AR-' in row['Document']:
                        selected_tags = deepcopy(tags + artags)
                    else:
                        selected_tags = deepcopy(tags)
                        gloss_element = etree.SubElement(tok_element, "gloss")
                        gloss_element.set('class', row['Manual_Lemma'])
                    for attr in selected_tags:
                        if pd.notna(row[attr]):
                            if attr=='Gloss':
                                full_gloss_element = etree.SubElement(tok_element, "gloss_full")
                                glosses = remove_plurals(row[attr])
                                # glosses = row[attr]
                                full_gloss_element.set('class', glosses)                                
                                glosses = re.split(r',|;', row[attr])
                                for gloss in set(glosses):
                                    gloss_element = etree.SubElement(tok_element, "gloss")
                                    gloss_element.set('class', gloss)                                    
                            else:                                
                                attr_element = etree.SubElement(tok_element, attr.lower())
                                attr_element.set('class', row[attr])
                        # else:
                        #     tok_element.set(attr,"")
                            
                    tok_element.set('idx', str(word_counter))
                    word_counter += 1
                
    return etree.ElementTree(root_element)


def index_tei(tei):
    for idx, tag in enumerate(tei.xpath('//word|//punc')):
        # xml:id="w.wx.1153439"
        # set the id attribute of the w element with namespace
        tag.set('{http://www.w3.org/XML/1998/namespace}id', f"w.wx.{idx+1}")
        
    return tei


if __name__ == "__main__":
    # load corpus as dataframes
    EN_analyzed = pd.read_csv('../../zaebuc_written/ZAEBUC-v1.1/EN-all.extracted.corrected.analyzed.corrected-FINAL.tsv',sep='\t')
    AR_analyzed = pd.read_csv('../../zaebuc_written/ZAEBUC-v1.1/AR-all.extracted.corrected.analyzed.corrected-FINAL.tsv',sep='\t')
    ENxmls = EN_analyzed.query('Line_Index.isna()')['Document'].replace('</doc>', pd.NA).dropna()
    ARxmls = AR_analyzed.query('Line_Index.isna()')['Document'].replace('</doc>', pd.NA).dropna()
    ARxmldf = ARxmls.apply(lambda x: pd.Series(etree.fromstring(x).attrib))
    ENxmldf = ENxmls.apply(lambda x: pd.Series(etree.fromstring(x).attrib))
    EN_analyzed = EN_analyzed.dropna(subset=['Line_Index'])
    AR_analyzed = AR_analyzed.dropna(subset=['Line_Index'])


    # concatenate arabic and english corpus
    samplelen = 1000
    merged_analyzed = pd.concat([AR_analyzed[:samplelen], EN_analyzed[:samplelen]])
    # merged_analyzed = pd.concat([AR_analyzed[:],EN_analyzed[:]])
    

    # write xml    
    tei = create_tei(merged_analyzed[:], "ZAEBUC Written Corpus")
    tei = index_tei(tei)
    tei.write("../data/zaebuc_written.xml", pretty_print=True, xml_declaration=True, encoding="utf-8")