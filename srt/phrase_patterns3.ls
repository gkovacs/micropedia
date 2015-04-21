require! {
  jsonfile
}

{sum} = require 'prelude-ls'

{parseSexp} = require './parse_sexp'

lang = 'eng' # cmn eng
lines_english = jsonfile.readFileSync "tatoeba_#{lang}.json"
parse_trees = jsonfile.readFileSync "parse_trees_tatoeba_#{lang}.json"
complexity_scores = jsonfile.readFileSync "complexity_scores_tatoeba_#{lang}.json"

target_phrase_list = ['find']
# ['change'] #['change', 'without notice']
# in at go change tranform find finds
# 在 得 变化 改变 变成

# now we should also discover extremely common bigrams, ie "go to" (which is currently subsumed under the VP -> go PP rule)
# and then expand that to more specific phrase structures like VP -> go to NP
# basically, if we expand out the terminals of the PP, is there one that occurs extremely frequently? in this case, "to" or "on" occur extremely frequently in initial position

find_start_and_end = (target_phrase_list, parsed) ->
  {childrentext} = parsed
  #if childrentext.indexOf('change') != -1
  #  console.log childrentext
  #  console.log target_phrase_list
  #else
  #  return [-1, -1]
  for target_idx in [0 to childrentext.length - target_phrase_list.length]
    if target_phrase_list === childrentext[target_idx til target_idx + target_phrase_list.length]
      #console.log [target_idx, target_idx + target_phrase_list.length]
      return [target_idx, target_idx + target_phrase_list.length]
  #console.log 'not found!'
  return [-1, -1]

aggregate_sentence_patterns = (tree) ->
  output = []
  parsed = parseSexp tree
  [target_idx,target_idx_end] = find_start_and_end target_phrase_list, parsed
  if target_idx != -1
    pattern = parsed.childrenpos[to]
    #if pattern.length == 1 # do not want trivial rules along the lines of PRT -> in
    #  return []
    for cur_idx,i in [target_idx til target_idx_end]
      pattern[cur_idx] = target_phrase_list[i]
    #pattern[target_idx] = target_phrase
    output.push {target_idx, target_idx_end, pos: parsed.pos, pattern: pattern, childrentext: parsed.childrentext}
    return output # do not want to go dig deeper if have already found the occurrence
  for childtree in parsed.childrentree
    for pattern in aggregate_sentence_patterns(childtree)
      output.push pattern
  return output

#usage_counts = {}
#usage_examples = {}
usage_info = {}

addtohistogram = (pattern, childrentext, output) ->
  if pattern.length != childrentext.length
    throw 'unequal lengths'
  if not output? or output.length == 0
    output = []
    for i in [0 til pattern.length]
      output.push {}
  for i in [0 til pattern.length]
    pattern_pos = pattern[i]
    child_text = childrentext[i]
    if not output[i][child_text]?
      output[i][child_text] = 0
    output[i][child_text] += 1
  return output

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
    {pattern, childrentext, pos} = pattern_info
    orig_pattern = pattern
    pattern = pos + ' -> ' + orig_pattern.join(' ')
    if not usage_info[pattern]?
      usage_info[pattern] = {
        counts: 1
        orig_pattern: orig_pattern
        examples: [line]
        childrentext: [childrentext]
        patterncounts: addtohistogram(orig_pattern, childrentext)
      }
    else
      addtohistogram orig_pattern, childrentext, usage_info[pattern].patterncounts
      usage_info[pattern].counts += 1
      usage_info[pattern].childrentext.push childrentext
      if usage_info[pattern].examples.length < 10
        usage_info[pattern].examples.push line
        usage_info[pattern].examples.sort (a,b) -> complexity_scores[a] - complexity_scores[b] # increasing complexity
      else
        if complexity_scores[line] < usage_info[pattern].examples[*-1]
          usage_info[pattern].examples[*-1] = line
          usage_info[pattern].examples.sort (a,b) -> complexity_scores[a] - complexity_scores[b] # increasing complexity

all_patterns = Object.keys usage_info

all_patterns.sort (a, b) -> usage_info[a].counts - usage_info[b].counts

for pattern in all_patterns
  common_patterns = {}
  total_counts = usage_info[pattern].counts
  #total_counts = [counts for _,counts of usage_info[pattern].patterncounts] |> sum
  for pattern_counts_for_pos,pos_idx in usage_info[pattern].patterncounts
    {target_idx, target_idx_end} = usage_info[pattern]
    if pos_idx == target_idx
      continue
    for subbed_word,counts of pattern_counts_for_pos
      curpattern_list = usage_info[pattern].orig_pattern[to]
      #curpattern_list[target_idx] = target_phrase
      for cur_idx,i in [target_idx til target_idx_end]
        curpattern_list[cur_idx] = target_phrase_list[i]
      curpattern_list[pos_idx] = subbed_word
      curpattern = curpattern_list.join(' ')
      fraction = counts / total_counts
      #console.log "fraction for '#curpattern' is #fraction counts is #counts total counts is #total_counts"
      if fraction > 0.1 and counts > 1
        common_patterns[curpattern] = counts
  console.log pattern + ' : ' + total_counts + ' : ' + JSON.stringify(common_patterns) + ' : ' + JSON.stringify(usage_info[pattern].examples)
