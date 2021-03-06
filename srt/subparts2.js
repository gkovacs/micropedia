// Generated by LiveScript 1.3.1
(function(){
  var terminals, getChildren, getParseConstituents, parseSexp, tree, jsonfile, fs, longestkey, all_cards, lines_english, parse_trees, makecards, num_sentences, partnum, i$, len$, idx, line, constituents, sentence, cards, j$, len1$, card;
  terminals = function(s, lang){
    var output, current_terminal, i$, len$, c, last_paren_type, to_print, ref$, tag, terminal;
    output = [];
    current_terminal = [];
    for (i$ = 0, len$ = s.length; i$ < len$; ++i$) {
      c = s[i$];
      if (c === '(') {
        last_paren_type = '(';
        current_terminal = [];
      } else if (c === ')') {
        if (last_paren_type === '(') {
          if (current_terminal.length > 0) {
            to_print = current_terminal.join('');
            ref$ = to_print.split(' '), tag = ref$[0], terminal = ref$[1];
            output.push(terminal);
          }
        }
        last_paren_type = ')';
        current_terminal = [];
      } else {
        current_terminal.push(c);
      }
    }
    if (lang === 'zh') {
      return output.join('');
    }
    return output.join(' ');
  };
  getChildren = function(s){
    var curchild, children, depth, i$, len$, c;
    curchild = [];
    children = [];
    depth = 0;
    for (i$ = 0, len$ = s.length; i$ < len$; ++i$) {
      c = s[i$];
      if (c === '(') {
        depth += 1;
      }
      if (depth >= 2) {
        curchild.push(c);
      }
      if (c === ')') {
        depth -= 1;
        if (depth === 1) {
          children.push(curchild.join(''));
          curchild = [];
        }
      }
    }
    return children;
  };
  getParseConstituents = function(parse, lang){
    var output, agenda, current, i$, ref$, len$, child, curt, childt;
    output = {};
    agenda = [parse];
    while (agenda.length > 0) {
      current = agenda.pop(0);
      for (i$ = 0, len$ = (ref$ = getChildren(current)).length; i$ < len$; ++i$) {
        child = ref$[i$];
        agenda.push(child);
        curt = terminals(current, lang);
        childt = terminals(child, lang);
        if (curt !== childt) {
          if (output[curt] == null) {
            output[curt] = [];
          }
          output[curt].push(childt);
        }
      }
    }
    return output;
  };
  parseSexp = require('./parse_sexp').parseSexp;
  tree = "( (S (NP (VB Let) (POS 's)) (VP (VBP try) (NP (NN something))) (. .)) )";
  console.log(parseSexp(tree));
  process.exit();
  jsonfile = require('jsonfile');
  fs = require('fs');
  longestkey = function(constituents){
    var longest_key, i$, ref$, len$, x;
    longest_key = '';
    for (i$ = 0, len$ = (ref$ = Object.keys(constituents)).length; i$ < len$; ++i$) {
      x = ref$[i$];
      if (x.length > longest_key.length) {
        longest_key = x;
      }
    }
    return longest_key;
  };
  all_cards = [];
  lines_english = jsonfile.readFileSync('tatoeba_eng.json');
  parse_trees = jsonfile.readFileSync('parse_trees_tatoeba_eng.json');
  makecards = function(sentence, constituents, parent){
    var output, card, children, i$, len$, child, child_cards, j$, len1$, child_card;
    output = [];
    card = {};
    card.sentence = sentence;
    if (parent != null) {
      card.parent = parent;
    }
    children = constituents[sentence];
    if (children != null) {
      card.children = children;
    }
    output.push(card);
    if (children != null) {
      for (i$ = 0, len$ = children.length; i$ < len$; ++i$) {
        child = children[i$];
        child_cards = makecards(child, constituents, sentence);
        for (j$ = 0, len1$ = child_cards.length; j$ < len1$; ++j$) {
          child_card = child_cards[j$];
          output.push(child_card);
        }
      }
    }
    return output;
  };
  num_sentences = lines_english.length;
  partnum = 0;
  for (i$ = 0, len$ = lines_english.length; i$ < len$; ++i$) {
    idx = i$;
    line = lines_english[i$];
    if (idx % 100000 === 0 && all_cards.length > 0) {
      jsonfile.writeFileSync("cards_tatoeba_eng_notrans_" + partnum + ".json", all_cards);
      all_cards = [];
      partnum += 1;
      console.log(idx + ' / ' + num_sentences + ' : ' + line);
    }
    tree = parse_trees[line];
    if (tree == null) {
      continue;
    }
    constituents = getParseConstituents(tree, 'en');
    sentence = longestkey(constituents);
    cards = makecards(sentence, constituents, null);
    cards[0].idx = idx;
    cards[0].sentence_orig = line;
    for (j$ = 0, len1$ = cards.length; j$ < len1$; ++j$) {
      card = cards[j$];
      all_cards.push(card);
      console.log(card);
    }
    break;
  }
}).call(this);
