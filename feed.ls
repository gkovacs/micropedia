J = $.jade

export insertArticle = (article_name) ->
  #$.get('/w/' + article_name, (data) ->
  havearticle = (mdata) ->
    if mdata.indexOf('article does not exist:') == 0
      toastr.error 'no such article: ' + article_name
      return
    #metadata =
    #data = markdown.toHTML(mdata)
    data = marked(mdata)
    ndata = $(data)
    for x in ndata.find('a')
      target_article = $(x).attr('href')
      if target_article.indexOf('://') != -1 # external link
        $(x).attr('target', '_blank')
      else
        $(x).attr('href', '#').attr('onclick', "insertArticle('#{target_article}')")
      $(x).attr('data-toggle', 'tooltip').attr('data-placement', 'bottom')
      if $(x).attr('title')?
        $(x).addClass('needtoggle')
      #if not $(x).attr('title')?
      #  $(x).attr('title', target_article)
    newdiv = J('div').css({
      'padding': '10px'
      'margin': '10px'
      'border-color': 'black'
      'border-style': 'solid'
      'border-width': '1px'
      'border-radius': '10px'
    }).html(ndata)
    $('#feeditems').prepend newdiv
    $('.needtoggle').tooltip()
    $('.needtoggle').removeClass('needtoggle')
  #$.get("/meta/#{article_name}", havemeta).fail ->
  #  toastr.error 'no such meta: ' + article_name
  #  return false
  #havemeta = (metayaml) ->
  #  $.get("/markdown/#{article_name}", (mdata) ->
  #    havearticle(metayaml, mdata)
  #  ).fail ->
  #    toastr.error 'no such article: ' + article_name
  #    return false
  $.get("/markdown/#{article_name}", (mdata) ->
    havearticle(mdata)
  ).fail ->
    toastr.error 'no such article: ' + article_name
    return false

export getUrlParameters = ->
  url = window.location.href
  hash = url.lastIndexOf('#')
  if hash != -1
    url = url.slice(0, hash)
  map = {}
  parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, (m,key,value) ->
    map[key] = decodeURI(value)
  )
  return map


$(document).ready ->
  param = getUrlParameters()
  article = param.page ? 'index'
  insertArticle article
