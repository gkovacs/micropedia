require! {
  jsonfile
}

word_counts = jsonfile.readFileSync 'word_counts_tatoeba_eng.json'

words = Object.keys word_counts

words.sort (a, b) -> word_counts[a] - word_counts[b]

for word in words
  console.log word + ':' + word_counts[word]
