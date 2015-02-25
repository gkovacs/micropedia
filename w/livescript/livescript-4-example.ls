$(document).ready ->
  checkcode = ->
    usercode = $('#inputcode').val()
    fibcode = $('#fibcode').text().split('Check').join(usercode)
    livescript = require('LiveScript')
    #console.log fibcode
    try
      jscode = livescript.compile(fibcode)
    catch
      toastr.error(e.message)
      return
    #console.log jscode
    try
      results = eval(jscode)
    catch
      toastr.error(e.message)
      return
    toastr.success('Yay your answer is correct. You win 1 internetz')
    #$('#inputcode').attr('disabled', true)
    #$('#checkbutton').attr('disabled', true)
    #console.log test()
  $('#checkbutton').click ->
    checkcode()
  $('#inputcode').keydown (evt) ->
    code = evt.keyCode ? evt.which
    if code == 13
      evt.preventDefault()
      checkcode()
