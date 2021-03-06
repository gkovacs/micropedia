// Generated by LiveScript 1.3.1
(function(){
  var jsonfile, parseSexp, lines_english, parse_trees, complexity_scores, hasalphabetic, getWords, words_to_examples, i$, len$, idx, line, tree, words, j$, len1$, word, ref$, e;
  jsonfile = require('jsonfile');
  parseSexp = require('./parse_sexp').parseSexp;
  lines_english = jsonfile.readFileSync('tatoeba_eng.json');
  parse_trees = jsonfile.readFileSync('parse_trees_tatoeba_eng.json');
  complexity_scores = jsonfile.readFileSync('complexity_scores_tatoeba_eng.json');
  hasalphabetic = function(s){
    var alpha, i$, len$, c;
    alpha = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"].concat(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]);
    for (i$ = 0, len$ = s.length; i$ < len$; ++i$) {
      c = s[i$];
      if (alpha.indexOf(c) !== -1) {
        return true;
      }
    }
    return false;
  };
  getWords = function(tree){
    var parsed;
    parsed = parseSexp(tree);
    return parsed.textlist;
  };
  words_to_examples = {};
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
      try {
        if (words_to_examples[word] == null || typeof words_to_examples[word] === 'function') {
          words_to_examples[word] = [line];
        } else {
          if (words_to_examples[word].length < 10) {
            words_to_examples[word].push(line);
            words_to_examples[word] = words_to_examples[word].sort(fn$);
          } else {
            if (complexity_scores[line] < complexity_scores[(ref$ = words_to_examples[word])[ref$.length - 1]]) {
              (ref$ = words_to_examples[word])[ref$.length - 1] = line;
              words_to_examples[word] = words_to_examples[word].sort(fn1$);
            }
          }
        }
      } catch (e$) {
        e = e$;
        console.log(word);
        console.log(words);
        console.log(tree);
        console.log(line);
        process.exit();
      }
    }
  }
  jsonfile.writeFileSync('word_examples_tatoeba_eng.json', words_to_examples);
  function fn$(a, b){
    return complexity_scores[a] - complexity_scores[b];
  }
  function fn1$(a, b){
    return complexity_scores[a] - complexity_scores[b];
  }
}).call(this);
