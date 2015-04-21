{parse_sentence} = require('./parse_sentence')
{parseSexp} = require('./parse_sexp')



target_sentence = 'This paper introduces architectural and interaction patterns
for integrating crowdsourced human contributions directly
into user interfaces.'
parse_sentence target_sentence, 'en', (sexp) ->
  console.log sexp
  parsed = parseSexp sexp
  console.log parsed
