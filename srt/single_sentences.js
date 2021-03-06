// Generated by LiveScript 1.3.1
(function(){
  var jsonfile, sentenceTokenizer, tokenizer, output, sentence, ref$, tree, sentences;
  jsonfile = require('jsonfile');
  sentenceTokenizer = require('sentence-tokenizer');
  tokenizer = new sentenceTokenizer();
  output = {};
  for (sentence in ref$ = jsonfile.readFileSync('parse_trees_tatoeba_eng_tokenized_all.json')) {
    tree = ref$[sentence];
    tokenizer.setEntry(sentence);
    sentences = tokenizer.getSentences();
    if (sentences.length > 1) {
      continue;
    }
    output[sentence] = tree;
  }
  jsonfile.writeFileSync('parse_trees_tatoeba_eng_v2.json', output);
}).call(this);
