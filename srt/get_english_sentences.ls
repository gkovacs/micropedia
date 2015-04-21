require! {
  jsonfile
  'read-each-line'
}

sentences = []

readEachLine 'sentences.csv', (line) ->
  parts = line.split('\t')
  sid = parts[0]
  lang = parts[1]
  sentence = parts[2 to].join('\t')
  if lang == 'eng' and sentence.length < 500
    sentences.push sentence

jsonfile.writeFileSync 'tatoeba_eng.json', sentences
