require! {
  jsonfile
}

{sum} = require 'prelude-ls'

{parseSexp} = require './parse_sexp'

lines_english = jsonfile.readFileSync 'tatoeba_eng.json'
parse_trees = jsonfile.readFileSync 'parse_trees_tatoeba_eng.json'
complexity_scores = jsonfile.readFileSync 'complexity_scores_tatoeba_eng.json'

target_phrase = 'at least CD' # in at go

isPOSTag = (word) ->
  if word == word.toUpperCase()
    return true
  return false

build_query = (str) ->
  query = []
  for word in str.split(' ')
    if isPOSTag word
      query.push {
        type: 'pos'
        text: word
      }
    else
      query.push {
        type: 'word'
        text: word
      }
  return query

target_query = build_query target_phrase

matches_query = (tree) ->
  parsed = parseSexp tree
  {textlist, poslist} = parsed
  

for line in lines_english
  tree = parse_trees[line]
  if not tree?
    continue
  parsed = parseSexp tree
  {textlist, poslist} = parsed
  if matches_query(tree, parsed)
  console.log parsed

#console.log target_query
