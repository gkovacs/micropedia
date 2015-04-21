require! {
  jsonfile
}

{parseSexp} = require './parse_sexp'

lang = 'cmn'
lines_english = jsonfile.readFileSync("tatoeba_#{lang}.json")
parse_trees = jsonfile.readFileSync("parse_trees_tatoeba_#{lang}.json")

getWords = (s) ->
  output = []
  parsed = parseSexp s
  return parsed.textlist

word_counts = {}

for line,idx in lines_english
  if idx % 10000 == 0
    console.log idx + ' / ' + lines_english.length
  tree = parse_trees[line]
  if not tree?
    continue
  words = getWords tree
  for word in words
    word = word.toLowerCase()
    if not word_counts[word]?
      word_counts[word] = 1
    else
      word_counts[word] += 1

jsonfile.writeFileSync "word_counts_tatoeba_#{lang}.json", word_counts
