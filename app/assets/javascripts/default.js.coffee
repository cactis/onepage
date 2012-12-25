
$(document).ready ->
  $.fn.auto_external_link()


(($) ->
  $.fn.developmentMode = ->
    true if window.location.hostname.match('.local')

  $.fn.log = (msg, hr) ->
    if $.fn.developmentMode()
      console.log hr if hr && hr.length > 0
      console.log msg

  # 取得 dom_id 的 id 值
  $.fn.id = ->
    $(this).attr('id')#.split('_').pop() if $(this).attr('id')

  $.fn.auto_external_link = ->
    $("a.external").each ->
      $(this).attr "target", "_blank"
    $("a[href^='http']").each ->
      $(this).attr "target", "_blank"  if @href.indexOf(location.hostname) == -1
) jQuery


$.fn.ajax_reset = ->
  # $("#loader").remove()
  # $("body").css("cursor", "auto");
  # $.colorbox.remove()
  # $(".colorbox").colorbox()
  # $.fn.wrapImgAsColorbox()
  # $('.toolbars a').addClass('button')
  $.fn.auto_external_link()
  # $("body").css("cursor", "default");


jQuery.ajaxSetup
  beforeSend: ->
    # $("body").prepend("<div id='loader'></div>")
    # $("body").css("cursor", "progress");
    # $.fn.log 'Ajax Call beforeSend...'
  complete: ->
    $.fn.ajax_reset()
    # $.fn.log 'Ajax Call Complete...'
  success: ->
    $.fn.ajax_reset()
    # $.fn.log 'Ajax Call Success...'
  error: ->
    # $.fn.log 'Ajax Call Error...'
    $.fn.ajax_reset()


$.fn.truncate = (str, min, max) ->
  length = $.fn.random_by_range(min, max)
  postfix = if str.length > length then '...' else ''
  str.substring(0, length) + postfix

$.fn.random_by_range = (min,max) ->
  return Math.floor(Math.random()*(max-min+1)+min)


$.extend unescapeHTML: (html) ->
  htmlNode = document.createElement("DIV")
  htmlNode.innerHTML = html
  return htmlNode.innerText  if htmlNode.innerText isnt `undefined` # IE
  htmlNode.textContent # FF

$.extend randomString: (length, special) ->
  iteration = 0
  password = ""
  randomNumber = undefined
  special = false  if special is `undefined`
  while iteration < length
    randomNumber = (Math.floor((Math.random() * 100)) % 94) + 33
    unless special
      continue  if (randomNumber >= 33) and (randomNumber <= 47)
      continue  if (randomNumber >= 58) and (randomNumber <= 64)
      continue  if (randomNumber >= 91) and (randomNumber <= 96)
      continue  if (randomNumber >= 123) and (randomNumber <= 126)
    iteration++
    password += String.fromCharCode(randomNumber)
  password

$.extend log: (msg, hr) ->
  if $.fn.developmentMode()
    console.log hr if hr && hr.length > 0
    console.log msg  
