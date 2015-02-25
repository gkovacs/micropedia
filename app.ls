require! {
  express
  fs
  glob
  marked
  LiveScript
  jsonfile
}
$ = require 'cheerio'
# {markdown} = require('markdown')

app = express()

app.set 'view engine', 'jade'
app.set 'views', __dirname + '/static'

app.use express.static(__dirname + '/static')

app.listen(process.env.PORT ? 3000)

app.get '/feed', (req, res) ->
  res.render 'feed', {}

app.get '/', (req, res) ->
  #res.redirect '/w/index'
  res.render 'feed', {}

app.get '/w', (req, res) ->
  res.redirect '/w/index'

app.get '/wiki', (req, res) ->
  res.redirect '/w/index'

listproblems = (topic, callback) ->
  glob 'w/' + topic + '/*-problem.md', (err, files) ->
    files = [x.substring(x.lastIndexOf('/') + 1) for x in files]
    files = [x.substring(0, x.length - 3) for x in files]
    callback files

app.get '/listproblems', (req, res) ->
  listproblems (files) ->
    res.send JSON.stringify(files)

listproblems_markdown = (topic, callback) ->
  listproblems topic, (files) ->
    output = []
    for fn in files
      output.push "[#{fn}](#{fn})"
    callback output.join('\n\n')

listproblems_html = (topic, callback) ->
  listproblems_markdown topic, (mdata) ->
    callback marked(mdata)

app.get '/markdown/problems', (req, res) ->
  topic = req.query.topic ? '**'
  listproblems_markdown topic, (output) ->
    res.type 'text/plain'
    res.send output

app.get '/w/problems', (req, res) ->
  topic = req.query.topic ? '**'
  listproblems_html topic, (output) ->
    res.type 'text/html'
    res.send output

page_markdown = (name, callback) ->
  pattern = 'w/**/' + name + '.md'
  matches = glob.sync pattern
  if matches.length == 0
    callback(null)
    return
  filepath = matches[0]
  contents = fs.readFileSync(filepath, 'utf8')
  callback contents

page_html = (name, callback) ->
  page_markdown name, (mdata) ->
    if mdata == null
      callback(null)
    else
      callback marked(mdata)

app.get /^\/w\/(.+)/, (req, res) ->
  name = req.params[0]
  page_html name, (data) ->
    res.type 'text/html'
    if data == null
      res.send 'article does not exist: ' + name
    else
      res.send data

cards = jsonfile.readFileSync('cards.json')

mkexercise = (sentence) ->
  card = cards.filter((x) -> x.sentence == sentence)[0]
  {sentence, parent, engsub, translation, children, idx, pinyin} = card
  output = []
  #output.push sentence
  if children?
    child_links = []
    for child in children
      #child_links.push "[#child](zh-#child)"
      childcard = cards.filter((x) -> x.sentence == child)[0]
      child_links.push $('<a>').text(child).addClass('codelink').attr({
        href: 'zh-' + child
        title: childcard.translation
      })
    output.push child_links.join(' ')
  else
    output.push sentence
  output.push 'Try translating the above to English: <input type="text"></input>'
  if pinyin?
    output.push 'Pinyin: ' + pinyin
  if engsub?
    output.push 'English Subtitle: ' + engsub
  output.push 'Google Translate: ' + translation
  if parent?
    output.push "Parent: [#parent}](zh-#parent)"
  if idx?
    prevcard = cards.filter((x) -> x.idx == idx - 1)[0]
    nextcard = cards.filter((x) -> x.idx == idx + 1)[0]
    if prevcard?
      output.push ("Prev line (#{idx - 1}): " + $('<a>').text(prevcard.sentence).attr({
        href: 'zh-' + prevcard.sentence
        title: prevcard.engsub
      }))
    if nextcard?
      output.push ("Next line (#{idx + 1}): " + $('<a>').text(nextcard.sentence).attr({
        href: 'zh-' + nextcard.sentence
        title: nextcard.engsub
      }))
  return output.join('\n\n')

mktitlepage = ->
  output = []
  for card in cards.filter((x) -> x.idx?).sort((a,b) -> a.idx - b.idx)
    {sentence} = card
    output.push "[#sentence](zh-#sentence)"
  return output.join('\n\n')

app.get /^\/markdown\/zh-(.+)/, (req, res) ->
  sentence = req.params[0]
  res.type 'text/plain'
  res.send mkexercise(sentence)

app.get '/markdown/srt', (req, res) ->
  res.type 'text/plain'
  res.send mktitlepage()

app.get /^\/markdown\/(.+)/, (req, res) ->
  name = req.params[0]
  page_markdown name, (data) ->
    res.type 'text/plain'
    if data == null
      res.send 'article does not exist: ' + name
    else
      res.send data

app.get /^\/metadata\/(.+)/, (req, res) ->
  filename = req.params[0]
  pattern = 'w/**/' + filename + '.yaml'
  matches = glob.sync pattern
  if matches.length == 0
    res.send 'metadata does not exist: ' + filename
    return
  filepath = matches[0]
  res.sendFile filepath, {root: __dirname}
  #contents = fs.readFileSync(filepath, 'utf8')
  #res.type 'text/plain'
  #res.send contents

app.get /^\/png\/(.+)/, (req, res) ->
  filename = req.params[0]
  pattern = 'w/**/' + filename + '.png'
  matches = glob.sync pattern
  if matches.length == 0
    res.send 'png does not exist: ' + filename
    return
  filepath = matches[0]
  res.sendFile filepath, {root: __dirname}
  #contents = fs.readFileSync(filepath, 'utf8')
  #res.type 'image/png'
  #res.send contents

app.get /^\/js\/(.+)/, (req, res) ->
  filename = req.params[0]
  pattern = 'w/**/' + filename + '.js'
  matches = glob.sync pattern
  if matches.length == 0
    res.send 'js does not exist: ' + filename
    return
  filepath = matches[0]
  res.sendFile filepath, {root: __dirname}
  #contents = fs.readFileSync(filepath, 'utf8')
  #res.type 'image/png'
  #res.send contents

app.get /^\/ls\/(.+)/, (req, res) ->
  filename = req.params[0]
  pattern = 'w/**/' + filename + '.ls'
  matches = glob.sync pattern
  if matches.length == 0
    res.send 'ls does not exist: ' + filename
    return
  filepath = matches[0]
  res.sendFile filepath, {root: __dirname}
  #contents = fs.readFileSync(filepath, 'utf8')
  #res.type 'image/png'
  #res.send contents

app.get /^\/lsc\/(.+)/, (req, res) ->
  filename = req.params[0]
  pattern = 'w/**/' + filename + '.ls'
  matches = glob.sync pattern
  if matches.length == 0
    res.send 'ls does not exist: ' + filename
    return
  filepath = matches[0]
  #res.sendFile filepath, {root: __dirname}
  contents = fs.readFileSync(filepath, 'utf8')
  res.type 'text/javascript'
  res.send LiveScript.compile(contents)
  #res.send contents
