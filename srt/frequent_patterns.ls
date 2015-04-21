require! {
  jsonfile
}

{parseSexp} = require './parse_sexp'

lines_english = jsonfile.readFileSync('tatoeba_eng.json')
parse_trees = jsonfile.readFileSync('parse_trees_tatoeba_eng.json')

hasalphabetic = (s) ->
  alpha = [\a to \z] ++ [\A to \Z]
  for c in s
    if alpha.indexOf(c) != -1
      return true
  return false

getGrammarPatterns = (s) ->
  output = []
  parsed = parseSexp s
  if parsed.pos == '' and parsed.childrentree.length == 1
    return getGrammarPatterns(parsed.childrentree[0])
  #console.log parsed
  output.push parsed.childrenpos.filter((x) -> x != '.').join(' ')
  for child in parsed.childrentree
    for pattern in getGrammarPatterns(child)
      output.push pattern
  return output

patterns_dict = {}

for line,idx in lines_english
  if idx % 10000 == 0
    console.log idx + ' / ' + lines_english.length
  tree = parse_trees[line]
  if not tree?
    continue
  patterns = getGrammarPatterns tree
  for pattern in patterns
    if not patterns_dict[pattern]?
      patterns_dict[pattern] = 1
    else
      patterns_dict[pattern] += 1

jsonfile.writeFileSync('patterns_dict_tatoeba_eng.json', patterns_dict)
