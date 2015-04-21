// Generated by LiveScript 1.3.1
(function(){
  var jsonfile, asyncblock, querystring, request, input_file, parser_lang, output_file, sentences, parse_trees, num_sentences;
  jsonfile = require('jsonfile');
  asyncblock = require('asyncblock');
  querystring = require('querystring');
  request = require('request');
  input_file = 'tatoeba_eng.json';
  parser_lang = 'en';
  output_file = 'parse_trees_tatoeba_eng.json';
  sentences = jsonfile.readFileSync(input_file);
  parse_trees = {};
  num_sentences = sentences.length;
  asyncblock(function(flow){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = sentences).length; i$ < len$; ++i$) {
      (fn$.call(this, i$, ref$[i$]));
    }
    return jsonfile.writeFileSync(output_file, parse_trees);
    function fn$(idx, sentence){
      var getParse;
      getParse = function(text, callback){
        return request('http://localhost:3555/parse?' + querystring.stringify({
          lang: parser_lang,
          sentence: text
        }), function(err, res, body){
          parse_trees[text] = body;
          return callback();
        });
      };
      getParse(sentence, flow.add());
      console.log(idx + " of " + num_sentences + ": " + sentence);
      flow.wait();
    }
  });
}).call(this);
