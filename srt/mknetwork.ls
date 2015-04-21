require! {
  fs
  srt
  asyncblock
  jsonfile
  request
  querystring
}

lines_chinese = []
parse_trees = {}
ref_translations = {}

srt '黑色社2以和为贵_sim_en.srt', (err, data) ->
  asyncblock (flow) ->
    #idx = 0
    for let num,subline of data
      subtext = subline.text.trim()
      numlines = subtext.split('\n').length
      #++idx
      #if idx > 2
      #  return
      if numlines != 2
        throw new Exception('expected 2 lines: ' + subtext)
      [chinese,english] = subtext.split('\n')
      getParse = (text, callback) ->
        request 'http://geza.csail.mit.edu:3555/parse?' + querystring.stringify({lang: 'zh', sentence: chinese}), (err, res, body) ->
          parse_trees[chinese] = body
          callback()
      #getParse chinese, flow.add()
      console.log chinese
      lines_chinese.push chinese
      #flow.wait()
      ref_translations[chinese] = english
    console.log parse_trees
    #jsonfile.writeFileSync 'lines_chinese.json', lines_chinese
    #jsonfile.writeFileSync 'parse_trees.json', parse_trees
    jsonfile.writeFileSync 'ref_translations.json', ref_translations
