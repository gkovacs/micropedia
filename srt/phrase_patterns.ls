require! {
  jsonfile
}

{parseSexp} = require('./parse_sexp')

lang = 'cmn'
lines_english = jsonfile.readFileSync "tatoeba_#{cmn}.json"
parse_trees = jsonfile.readFileSync "parse_trees_tatoeba_#{cmn}.json"
complexity_scores = jsonfile.readFileSync "complexity_scores_tatoeba_#{cmn}.json"

target_phrase = '在' # in at go

# now we should also discover extremely common bigrams, ie "go to" (which is currently subsumed under the VP -> go PP rule)
# and then expand that to more specific phrase structures like VP -> go to NP
# basically, if we expand out the terminals of the PP, is there one that occurs extremely frequently? in this case, "to" or "on" occur extremely frequently in initial position

aggregate_sentence_patterns = (tree) ->
  output = []
  parsed = parseSexp tree
  if parsed.childrentext.indexOf(target_phrase) != -1
    pattern = parsed.childrenpos[to]
    #if pattern.length == 1 # do not want trivial rules along the lines of PRT -> in
    #  return []
    pattern[parsed.childrentext.indexOf(target_phrase)] = target_phrase
    output.push {pos: parsed.pos, pattern: pattern.join(' '), curtext: parsed.curtext}
    return output # do not want to go dig deeper if have already found the occurrence
  for childtree in parsed.childrentree
    for pattern in aggregate_sentence_patterns(childtree)
      output.push pattern
  return output

usage_counts = {}
usage_examples = {}

for line,idx in lines_english
#for line,idx in ['You were taken in by her.']
  if idx > 10000
    break
  tree = parse_trees[line]
  if not tree?
    continue
  parsed = parseSexp tree
  #console.log <| tree |> parseSexp |> (.childrentree[0]) |> parseSexp |> (.childrentree[1]) |> parseSexp |> (.childrentree[1]) |> parseSexp
  #if parsed.textlist.indexOf(target_word) == -1
  #  continue
  for pattern_info in aggregate_sentence_patterns(tree)
    {pattern, curtext, pos} = pattern_info
    pattern = pos + ' -> ' + pattern
    if not usage_counts[pattern]?
      usage_counts[pattern] = 1
      usage_examples[pattern] = [line]
    else
      usage_counts[pattern] += 1
      if usage_examples[pattern].length < 10
        usage_examples[pattern].push line
        usage_examples[pattern].sort (a,b) -> complexity_scores[a] - complexity_scores[b] # increasing complexity
      else
        if complexity_scores[line] < usage_examples[pattern][*-1]
          usage_examples[pattern][*-1] = line
          usage_examples[pattern].sort (a,b) -> complexity_scores[a] - complexity_scores[b] # increasing complexity
  #console.log parseSexp(parseSexp(tree).childrentree[0])
  #console.log parseSexp(parseSexp(parseSexp(parseSexp(tree).childrentree[0]).childrentree[0]).childrentree[1])

all_patterns = Object.keys usage_counts

all_patterns.sort (a, b) -> usage_counts[a] - usage_counts[b]

for pattern in all_patterns
  console.log pattern + ' : ' + usage_counts[pattern] + ' : ' + JSON.stringify(usage_examples[pattern])
