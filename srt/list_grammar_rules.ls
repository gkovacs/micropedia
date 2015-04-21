require! {
  jsonfile
}

patterns_dict = jsonfile.readFileSync 'patterns_dict_tatoeba_eng.json'
patterns_examples = jsonfile.readFileSync 'patterns_examples_tatoeba_eng.json'

patterns = Object.keys patterns_dict

patterns.sort (x,y) -> patterns_dict[x] - patterns_dict[y]

for pattern in patterns
  console.log pattern + ':' + patterns_dict[pattern] + ' [ex]: ' + JSON.stringify(patterns_examples[pattern])
