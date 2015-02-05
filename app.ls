require! {
  express
  fs
  glob
  marked
}
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
