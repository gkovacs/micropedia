// Generated by LiveScript 1.3.1
(function(){
  var jsonfile, readEachLine, sentences, slice$ = [].slice;
  jsonfile = require('jsonfile');
  readEachLine = require('read-each-line');
  sentences = [];
  readEachLine('sentences.csv', function(line){
    var parts, sid, lang, sentence;
    parts = line.split('\t');
    sid = parts[0];
    lang = parts[1];
    sentence = slice$.call(parts, 2).join('\t');
    if (lang === 'eng' && sentence.length < 500) {
      return sentences.push(sentence);
    }
  });
  jsonfile.writeFileSync('tatoeba_eng.json', sentences);
}).call(this);