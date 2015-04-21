// Generated by LiveScript 1.3.1
(function(){
  var googletranslate, getpinyin, jsonfile, asyncblock, cards, newcards;
  googletranslate = require('./googletranslate');
  getpinyin = require('./getpinyin');
  jsonfile = require('jsonfile');
  asyncblock = require('asyncblock');
  cards = jsonfile.readFileSync('cards_notrans.json');
  newcards = [];
  asyncblock(function(flow){
    var i$, ref$, len$;
    for (i$ = 0, len$ = (ref$ = cards).length; i$ < len$; ++i$) {
      (fn$.call(this, ref$[i$]));
    }
    return jsonfile.writeFileSync('cards.json', newcards);
    function fn$(card){
      var addpinyin, addtranslation;
      addpinyin = function(card, callback){
        return getpinyin.getPinyinRateLimitedCached(card.sentence, function(ntext, pinyin){
          card.pinyin = pinyin;
          return callback();
        });
      };
      addtranslation = function(card, callback){
        return googletranslate.getTranslations(card.sentence, 'zh_CN', 'en', function(translations){
          card.translation = translations[0].translatedText;
          return callback();
        });
      };
      addpinyin(card, flow.add());
      flow.wait();
      addtranslation(card, flow.add());
      flow.wait();
      console.log(card);
      newcards.push(card);
    }
  });
}).call(this);