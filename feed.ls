J = $.jade

export insertArticle = (article_name) ->
  #$.get('/w/' + article_name, (data) ->
  havearticle = (mdata) ->
    if mdata.indexOf('article does not exist:') == 0
      toastr.error 'no such article: ' + article_name
      return
    data = markdown.toHTML(mdata)
    ndata = $(data)
    for x in ndata.find('a')
      target_article = $(x).attr('href')
      $(x).attr('href', '#').attr('onclick', "insertArticle('#{target_article}')")
    newdiv = J('div').css({
      'padding': '10px'
      'margin': '10px'
      'border-color': 'black'
      'border-style': 'solid'
      'border-width': '1px'
      'border-radius': '10px'
    }).html(ndata)
    $('#feeditems').prepend newdiv
  $.get("/markdown/#{article_name}", havearticle).fail ->
    toastr.error 'no such article: ' + article_name
    return false

$(document).ready ->
  insertArticle 'index'
