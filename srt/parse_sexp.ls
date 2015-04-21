getPOS = (s) ->
  output = []
  num_leftparens = 0
  for c in s
    if c == '('
      num_leftparens += 1
      continue
    if c == ' '
      break
    if num_leftparens == 1
      output.push c
  return output.join('')

initPropertiesTrue = (options, properties) ->
  for property in properties
    if not options[property]?
      options[property] = true

export parseSexp = (s, options) ->
  # default options
  if not options?
    options = {}
  initPropertiesTrue options, <[ childrentree childrenpos childrentext textlist poslist pos terminal curtext ]>
  # populate output structure
  output = {}
  if options.childrentree
    output.childrentree = []
  if options.childrenpos
    output.childrenpos = []
  if options.childrentext
    output.childrentext = []
  depth = 0
  curchild = []
  curnode = []
  seen_space = false
  for c in s
    if c == '('
      depth += 1
    else if c == ')'
      depth -= 1
      if depth == 1
        curchild.push c
        childtree = curchild.join('')
        if options.childrentree
          output.childrentree.push childtree
        if options.childrenpos
          output.childrenpos.push getPOS(childtree)
        if options.childrentext
          output.childrentext.push listText(childtree).join(' ')
        curchild = []
    else if c == ' '
      seen_space = true
    else if depth == 1 and seen_space
      curnode.push c
    if depth >= 2
      curchild.push c
  if options.pos
    output.pos = getPOS(s)
  if options.terminal
    if curnode.length > 0
      output.terminal = curnode.join('')
  if options.poslist
    output.poslist = listPOS(s)
  if options.textlist
    output.textlist = listText(s)
  if options.curtext
    output.curtext = listText(s).join(' ')
  return output

listPOS = (s) ->
  output = []
  {childrentree, pos, terminal} = parseSexp(s, {pos: true, terminal: true, curtext: false, childrentree: true, childrenpos: false, childrentext: false, textlist: false, poslist: false})
  if terminal?
    output.push pos
  for child in childrentree
    for pos in listPOS(child)
      output.push pos
  return output

listText = (s) ->
  output = []
  {childrentree, pos, terminal} = parseSexp(s, {pos: true, terminal: true, curtext: false, childrentree: true, childrenpos: false, childrentext: false, textlist: false, poslist: false})
  if terminal?
    output.push terminal
  for child in childrentree
    for terminal in listText(child)
      output.push terminal
  return output
