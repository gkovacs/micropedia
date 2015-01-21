require! {
  express
  fs
}
{markdown} = require('markdown')

app = express()

#app.use express.static(__dirname + '/static')

app.listen(process.env.PORT ? 3000)

app.get '/', (req, res) ->
  res.redirect '/w/index'

app.get '/w', (req, res) ->
  res.redirect '/w/index'

app.get /^\/w\/(.+)/, (req, res) ->
  filename = req.params[0]
  filepath = 'w/' + filename + '.md'
  if not fs.existsSync(filepath)
    res.send 'article does not exist: ' + filename
    return
  contents = fs.readFileSync(filepath, 'utf8')
  res.send markdown.toHTML(contents)
