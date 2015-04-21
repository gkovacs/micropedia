require! {
  jsonfile
}

{parseSexp} = require './parse_sexp'

lines_english = jsonfile.readFileSync('tatoeba_eng.json')
parse_trees = jsonfile.readFileSync('parse_trees_tatoeba_eng.json')
#word_ranks = jsonfile.readFileSync('word_ranks_tatoeba_eng.json')
complexity_scores = jsonfile.readFileSync('complexity_scores_tatoeba_eng.json')

hasalphabetic = (s) ->
  alpha = [\a to \z] ++ [\A to \Z]
  for c in s
    if alpha.indexOf(c) != -1
      return true
  return false

getWords = (tree) ->
  parsed = parseSexp tree
  return parsed.textlist

words_to_examples = {}

for line,idx in lines_english
  if idx % 10000 == 0
    console.log idx + ' / ' + lines_english.length
  tree = parse_trees[line]
  if not tree?
    continue
  words = getWords tree
  for word in words
    word = word.toLowerCase()
    try
      #if not words_to_examples[word]?
      if not words_to_examples[word]? or typeof words_to_examples[word] == 'function'
        words_to_examples[word] = [line]
      else
        if words_to_examples[word].length < 10
          words_to_examples[word].push line
          words_to_examples[word] = words_to_examples[word].sort (a, b) -> complexity_scores[a] - complexity_scores[b] # shortest will be at 0, longest will be at .length - 1
        else
          if complexity_scores[line] < complexity_scores[words_to_examples[word][*-1]] # shorter than the longest one
            words_to_examples[word][*-1] = line
            words_to_examples[word] = words_to_examples[word].sort (a, b) -> complexity_scores[a] - complexity_scores[b] # shortest will be at 0, longest will be at .length - 1
    catch
      console.log word
      console.log words
      console.log tree
      console.log line
      process.exit()

jsonfile.writeFileSync('word_examples_tatoeba_eng.json', words_to_examples)
