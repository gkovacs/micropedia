require! {
  jsonfile
}

lang = 'cmn'
word_counts = jsonfile.readFileSync "word_counts_tatoeba_#{lang}.json"

words = Object.keys word_counts

words.sort (a, b) -> word_counts[b] - word_counts[a]

word_ranks = {}

for word,idx in words
  rank = idx + 1
  console.log word + ':' + rank
  word_ranks[word] = rank

jsonfile.writeFileSync "word_ranks_tatoeba_#{lang}.json", word_ranks
