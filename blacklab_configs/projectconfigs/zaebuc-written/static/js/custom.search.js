 vuexModules.ui.getState().results.shared.getDocumentSummary = function(metadata, specialFields) {
   return 'Document: ' + JSON.parse(JSON.stringify(metadata['idx'][0]));
 }


vuexModules.ui.actions.results.shared.concordanceAnnotationId('word')