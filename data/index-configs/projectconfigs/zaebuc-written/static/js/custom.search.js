// Update query summary to show matched lemmas instead of CQL pattern
var lastSearchTerm = null;
var customSummaryActive = false;
var lastStorePattern = null;

// Poll the store for pattern changes
setTimeout(function() {
  var store = vuexModules.root.store;
  if (!store) return;

  setInterval(function() {
    var pattern = store.getters['query/patternSummary'];
    if (pattern === lastStorePattern) return;
    lastStorePattern = pattern;

    var summaryEl = document.querySelector('#summary .content');
    if (!summaryEl) return;

    if (pattern && pattern.includes('expanded_gloss')) {
      // Trigger the lemma lookup for expanded_gloss searches
      var match = pattern.match(/\[expanded_gloss="([^"]+)"\]/);
      if (match) {
        var searchTerm = match[1];
        if (searchTerm === lastSearchTerm) return;
        lastSearchTerm = searchTerm;

        var patt = encodeURIComponent('[expanded_gloss="' + searchTerm + '"]');
        fetch('/blacklab-server/zaebuc-written/hits?patt=' + patt + '&number=1000&wordsaroundhit=0&outputformat=json')
          .then(function(r) { return r.json(); })
          .then(function(data) {
            var uniqueLemmas = new Set();
            data.hits.forEach(function(hit) {
              if (hit.match && hit.match.lemma) {
                hit.match.lemma.forEach(function(w) { uniqueLemmas.add(w); });
              }
            });
            var lemmaList = Array.from(uniqueLemmas).sort().join(', ');
            summaryEl.style.overflow = 'visible';
            summaryEl.style.whiteSpace = 'normal';
            summaryEl.style.textOverflow = 'unset';
            summaryEl.style.maxWidth = 'none';
            summaryEl.style.display = 'block';
            summaryEl.textContent = '"' + searchTerm + '" — matched lemmas: ' + lemmaList;
            customSummaryActive = true;
          })
          .catch(function(err) { console.error('Fetch error:', err); });
      }
    } else if (pattern) {
      // Non-expanded_gloss search: show the raw CQL pattern and reset lastSearchTerm
      // so switching back to the same expanded_gloss term triggers a fresh fetch
      lastSearchTerm = null;
      customSummaryActive = false;
      if (summaryEl.textContent !== pattern) {
        summaryEl.textContent = pattern;
      }
    }
  }, 300);
}, 2000);

///////////////////

///////////////////
// this sets the doc id to display for each result, after "Document: " 
vuexModules.ui.getState().results.shared.getDocumentSummary = function(metadata, specialFields) {
   return 'Document: ' + JSON.parse(JSON.stringify(metadata['docId']));
 }

// this sets the result to 'word', 
// instead of the first indexed field in the formats file, 
// which is the expanded search
vuexModules.ui.actions.results.shared.concordanceAnnotationId('word')


var x = true;
var ui = vuexModules.ui.actions;
ui.helpers.configureAnnotations([
	[                          ,    'EXTENDED'    ,    'ADVANCED'    ,    'EXPLORE'    ,    'SORT'    ,    'GROUP'    ,    'RESULTS'    ,    'CONCORDANCE'    ],
	
	// Other
	['expanded_gloss'          ,                  ,        x         ,                 ,      x       ,       x       ,                 ,                     ],
	['word'                    ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,         x           ],
	['lemma'                   ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,         x           ],
	['manual_diacritized_lemma',                  ,                  ,                 ,              ,               ,                 ,         x           ],
	['tokenized'               ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,         x           ],
	['pos'                     ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,         x           ],
	['lemma_pos'               ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,         x           ],
	['gloss'                   ,                  ,                  ,        x        ,              ,       x       ,                 ,         x           ],
	['clean_gloss'             ,                  ,                  ,        x        ,              ,       x       ,        x        ,         x           ],
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