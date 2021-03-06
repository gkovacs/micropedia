// Generated by LiveScript 1.3.1
(function(){
  var jsonfile, parseSexp, lines_english, parse_trees, word_ranks, complexity_scores, complexity_score, i$, len$, line, tree, score;
  jsonfile = require('jsonfile');
  parseSexp = require('./parse_sexp').parseSexp;
  lines_english = jsonfile.readFileSync('tatoeba_eng.json');
  parse_trees = jsonfile.readFileSync('parse_trees_tatoeba_eng.json');
  word_ranks = jsonfile.readFileSync('word_ranks_tatoeba_eng.json');
  complexity_scores = {};
  complexity_score = function(tree){
    var parsed, words, score, i$, len$, word;
    parsed = parseSexp(tree);
    words = parsed.textlist;
    score = 0;
    for (i$ = 0, len$ = words.length; i$ < len$; ++i$) {
      word = words[i$];
      word = word.toLowerCase();
      score += word_ranks[word];
    }
    return score;
  };
  for (i$ = 0, len$ = lines_english.length; i$ < len$; ++i$) {
    line = lines_english[i$];
    tree = parse_trees[line];
    if (tree == null) {
      continue;
    }
    score = complexity_score(tree);
    console.log(line + ':' + score);
    complexity_scores[line] = score;
  }
  jsonfile.writeFileSync('complexity_scores_tatoeba_eng.json', complexity_scores);
}).call(this);
