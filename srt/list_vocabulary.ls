require! {
  jsonfile
}

word_counts = jsonfile.readFileSync 'word_counts_tatoeba_eng.json'
word_examples = jsonfile.readFileSync 'word_examples_tatoeba_eng.json'

words = Object.keys word_counts

words.sort (x,y) -> word_counts[x] - word_counts[y]

for word in words
  console.log word + ':' + word_counts[word] + ' [ex]: ' + JSON.stringify(word_examples[word])
