// Generated by LiveScript 1.3.1
(function(){
  var jsonfile, parseSexp, lines_english, parse_trees, getWords, word_counts, i$, len$, idx, line, tree, words, j$, len1$, word;
  jsonfile = require('jsonfile');
  parseSexp = require('./parse_sexp').parseSexp;
  lines_english = jsonfile.readFileSync('tatoeba_eng.json');
  parse_trees = jsonfile.readFileSync('parse_trees_tatoeba_eng.json');
  getWords = function(s){
    var output, parsed;
    output = [];
    parsed = parseSexp(s);
    return parsed.textlist;
  };
  word_counts = {};
  for (i$ = 0, len$ = lines_english.length; i$ < len$; ++i$) {
    idx = i$;
    line = lines_english[i$];
    if (idx % 10000 === 0) {
      console.log(idx + ' / ' + lines_english.length);
    }
    tree = parse_trees[line];
    if (tree == null) {
      continue;
    }
    words = getWords(tree);
    for (j$ = 0, len1$ = words.length; j$ < len1$; ++j$) {
      word = words[j$];
      word = word.toLowerCase();
      if (word_counts[word] == null) {
        word_counts[word] = 1;
      } else {
        word_counts[word] += 1;
      }
    }
  }
  jsonfile.writeFileSync('word_counts_tatoeba_eng.json', word_counts);
}).call(this);