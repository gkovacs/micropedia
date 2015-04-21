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

{parseSexp} = require('./parse_sexp')

tree =  "( (S (NP (VB Let) (POS 's)) (VP (VBP try) (NP (NN something))) (. .)) )"
#tree =  "(S (NP (VB Let) (POS 's)) (VP (VBP try) (NP (NN something))) (. .))"

#console.log parseSexp '(VP Let)'
#console.log listPOS(tree)
console.log parseSexp tree
#console.log getPOS tree
#console.log getChildren(getChildren(tree)[0])
#console.log getParseConstituents(tree)

process.exit()


#parsetree = "( (CP (IP (VP (VV 让) (NP (PN 我)) (IP (VP (ADVP (AD 先)) (VP (VV 收拾)))))) (SP 吧)) )"

require! {
  jsonfile
  fs
}

longestkey = (constituents) ->
  longest_key = ''
  for x in Object.keys(constituents)
    if x.length > longest_key.length
      longest_key = x
  return longest_key

all_cards = []

#lines_chinese = jsonfile.readFileSync('lines_chinese.json')
lines_english = jsonfile.readFileSync('tatoeba_eng.json')
#ref_translations = jsonfile.readFileSync('ref_translations.json')
parse_trees = jsonfile.readFileSync('parse_trees_tatoeba_eng.json')

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
      #output ++= child_cards
      for child_card in child_cards
        output.push child_card
  return output

num_sentences = lines_english.length

partnum = 0

for line,idx in lines_english
  if idx % 100000 == 0 and all_cards.length > 0
    jsonfile.writeFileSync "cards_tatoeba_eng_notrans_#{partnum}.json", all_cards
    all_cards = []
    partnum += 1
    console.log idx + ' / ' + num_sentences + ' : ' + line
  tree = parse_trees[line]
  if not tree?
    continue
  constituents = getParseConstituents tree, 'en'
  sentence = longestkey(constituents)
  #console.log sentence
  #console.log constituents
  cards = makecards(sentence, constituents, null)
  cards[0].idx = idx
  cards[0].sentence_orig = line
  #cards[0].engsub = ref_translations[line]
  #all_cards ++= cards
  for card in cards
    all_cards.push card
    console.log card
    #fs.appendFileSync 'cards_tatoeba_eng_notrans.jsonflat', JSON.stringify(card)
  break


#jsonfile.writeFileSync "cards_tatoeba_eng_notrans_#{partnum}.json", all_cards
