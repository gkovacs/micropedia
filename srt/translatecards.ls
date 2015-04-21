googletranslate = require './googletranslate'
getpinyin = require './getpinyin'

require! {
  jsonfile
  asyncblock
}

cards = jsonfile.readFileSync('cards_notrans.json')
newcards = []

asyncblock (flow) ->
  for let card in cards
    addpinyin = (card, callback) ->
      getpinyin.getPinyinRateLimitedCached card.sentence, (ntext, pinyin) ->
        card.pinyin = pinyin
        callback()
    addtranslation = (card, callback) ->
      googletranslate.getTranslations card.sentence, 'zh_CN', 'en', (translations) ->
        card.translation = translations[0].translatedText
        callback()
    addpinyin card, flow.add()
    flow.wait()
    addtranslation card, flow.add()
    flow.wait()
    console.log card
    newcards.push card
  jsonfile.writeFileSync('cards.json', newcards)
