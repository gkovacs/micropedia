terminals = (s, lang) ->
  output = []
  current_terminal = []
  for c in s
    if c == '('
      last_paren_type = '('
      current_terminal = []
    else if c == ')'
      if last_paren_type == '('
        if current_terminal.length > 0
          to_print = current_terminal.join('')
          [tag,terminal] = to_print.split(' ')
          output.push terminal
      last_paren_type = ')'
      current_terminal = []
    else
      current_terminal.push(c)
  if lang == 'zh'
    return output.join('')
  return output.join(' ')

getChildren = (s) ->
  curchild = []
  children = []
  depth = 0
  for c in s
    if c == '('
      depth += 1
    if depth >= 2
      curchild.push c
    if c == ')'
      depth -= 1
      if depth == 1
        children.push curchild.join('')
        curchild = []
  return children

getParseConstituents = (parse, lang) ->
  output = {}
  agenda = [parse]
  while agenda.length > 0
    current = agenda.pop(0)
    for child in getChildren(current)
      agenda.push child
      curt = terminals(current, lang)
      childt = terminals(child, lang)
      if curt != childt
        if not output[curt]?
          output[curt] = []
        output[curt].push childt
  return output

#parsetree = "( (CP (IP (VP (VV 让) (NP (PN 我)) (IP (VP (ADVP (AD 先)) (VP (VV 收拾)))))) (SP 吧)) )"

require! {
  jsonfile
}

longestkey = (constituents) ->
  longest_key = ''
  for x in Object.keys(constituents)
    if x.length > longest_key.length
      longest_key = x
  return longest_key

all_cards = []

lines_chinese = jsonfile.readFileSync('lines_chinese.json')
ref_translations = jsonfile.readFileSync('ref_translations.json')
parse_trees = jsonfile.readFileSync('parse_trees.json')

makecards = (sentence, constituents, parent) ->
  output = []
  card = {}
  card.sentence = sentence
  if parent?
    card.parent = parent
  children = constituents[sentence]
  if children?
    card.children = children
  output.push card
  if children?
    for child in children
      child_cards = makecards(child, constituents, sentence)
      output ++= child_cards
  return output

for line,idx in lines_chinese
  tree = parse_trees[line]
  constituents = getParseConstituents tree, 'zh'
  sentence = longestkey(constituents)
  #console.log sentence
  #console.log constituents
  cards = makecards(sentence, constituents, null)
  cards[0].idx = idx
  cards[0].sentence_orig = line
  cards[0].engsub = ref_translations[line]
  all_cards ++= cards

jsonfile.writeFileSync 'cards_notrans.json', all_cards
