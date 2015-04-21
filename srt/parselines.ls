require! {
  jsonfile
  asyncblock
  querystring
  request
}

input_file = 'tatoeba_eng.json'
parser_lang = 'en'
output_file = 'parse_trees_tatoeba_eng.json'

sentences = jsonfile.readFileSync input_file

parse_trees = {}

num_sentences = sentences.length

asyncblock (flow) ->
  for let sentence,idx in sentences
    getParse = (text, callback) ->
      request 'http://localhost:3555/parse?' + querystring.stringify({lang: parser_lang, sentence: text}), (err, res, body) ->
        parse_trees[text] = body
        callback()
    getParse sentence, flow.add()
    console.log "#{idx} of #{num_sentences}: #{sentence}"
    flow.wait()
  jsonfile.writeFileSync output_file, parse_trees
