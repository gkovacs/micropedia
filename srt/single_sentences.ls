require! {
  jsonfile
  'sentence-tokenizer'
}

tokenizer = new sentence-tokenizer()

output = {}

for sentence,tree of jsonfile.readFileSync('parse_trees_tatoeba_eng_tokenized_all.json')
  tokenizer.setEntry(sentence)
  sentences = tokenizer.getSentences()
  if sentences.length > 1
    continue
  #if sentence.split('.').length > 2
  #  continue
  output[sentence] = tree
jsonfile.writeFileSync('parse_trees_tatoeba_eng_v2.json', output)
