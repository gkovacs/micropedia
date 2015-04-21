require! {
  jsonfile
}

{parseSexp} = require './parse_sexp'

lang = 'cmn'
lines_english = jsonfile.readFileSync("tatoeba_#{lang}.json")
parse_trees = jsonfile.readFileSync("parse_trees_tatoeba_#{lang}.json")
word_ranks = jsonfile.readFileSync("word_ranks_tatoeba_#{lang}.json")

complexity_scores = {}
#tree_complexity_scores = {}

complexity_score = (tree) ->
  parsed = parseSexp(tree)
  words = parsed.textlist
  #console.log words
  score = 0
  for word in words
    word = word.toLowerCase()
    score += word_ranks[word]
  return score

#set_complexity_scores = (tree) ->
#  if complexity_scores[]

for line in lines_english
  tree = parse_trees[line]
  if not tree?
    continue
  score = complexity_score(tree)
  console.log line + ':' + score
  complexity_scores[line] = score

jsonfile.writeFileSync "complexity_scores_tatoeba_#{lang}.json", complexity_scores
#jsonfile.writeFileSync 'tree_complexity_scores_tatoeba_eng.json', tree_complexity_scores
