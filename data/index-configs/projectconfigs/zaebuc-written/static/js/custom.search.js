 vuexModules.ui.getState().results.shared.getDocumentSummary = function(metadata, specialFields) {
   return 'Document: ' + JSON.parse(JSON.stringify(metadata['docId']));
 }


vuexModules.ui.actions.results.shared.concordanceAnnotationId('word')


var x = true;
var ui = vuexModules.ui.actions;
ui.helpers.configureAnnotations([
	[                          ,    'EXTENDED'    ,    'ADVANCED'    ,    'EXPLORE'    ,    'SORT'    ,    'GROUP'    ,    'RESULTS'    ,    'CONCORDANCE'    ],
	
	// Other
	['gloss_search'            ,                  ,        x         ,                 ,      x       ,       x       ,                 ,                     ],
	['word'                    ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,         x           ],
	['lemma'                   ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,         x           ],
	['manual_diacritized_lemma',                  ,                  ,                 ,              ,               ,                 ,         x           ],
	['tokenized'               ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,         x           ],
	['pos'                     ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,         x           ],
	['gloss'                   ,                  ,                  ,        x        ,              ,       x       ,        x        ,         x           ],
	['core_pgn'                ,                  ,                  ,                 ,              ,               ,                 ,         x           ],
	['pron_pgn'                ,                  ,                  ,                 ,              ,               ,                 ,         x           ],
]);x
ui.helpers.configureMetadata([
	[                       ,    'FILTER'    ,    'SORT'    ,    'GROUP'    ,    'RESULTS/HITS'    ,    'RESULTS/DOCS'    ,    'EXPORT'    ],
	
	// Metadata
	['cefr_1'               ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['cefr_2'               ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['cefr_3'               ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['cefr_avg'             ,       x        ,      x       ,       x       ,         x            ,                      ,                ],
	['college'              ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['course'               ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['days_between_tasks'   ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['earlier_task_language',       x        ,      x       ,       x       ,                      ,                      ,                ],
	['fromInputFile'        ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['gender'               ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['handwritten'          ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['docId'                ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['language'             ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['major'                ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['residence'            ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['safe_assign_score'    ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['school_language'      ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['school_type'          ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['split'                ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['textDirection'        ,                ,              ,               ,                      ,                      ,                ],
	['topic'                ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['word_count'           ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['writer_id'            ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['writing_mins'         ,       x        ,      x       ,       x       ,                      ,                      ,                ],
	['year'                 ,       x        ,      x       ,       x       ,                      ,                      ,                ],
]);