require! {
  request
  querystring
}

export parse_sentence = (sentence, lang, callback) ->
  request 'http://localhost:3555/parse?' + querystring.stringify({lang: lang, sentence: sentence}), (err, res, body) ->
    callback body
