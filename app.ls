require! {
  express
  fs
}
{markdown} = require('markdown')

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

app.get /^\/w\/(.+)/, (req, res) ->
  filename = req.params[0]
  filepath = 'w/' + filename + '.md'
  if not fs.existsSync(filepath)
    res.send 'article does not exist: ' + filename
    return
  contents = fs.readFileSync(filepath, 'utf8')
  res.send markdown.toHTML(contents)
