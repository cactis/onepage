host = 'http://' + window.location.host
channel = host + ":9293/pusher"

$(document).ready ->
  reload_page gon.data

  $ ->
    faye = new Faye.Client(channel)
    faye.subscribe "/pages/" + gon.page_id, (data) ->
      data = JSON.parse($.unescapeHTML(data))
      reload_page(data)


reload_page = (data) ->
  $("*[data-type=preview]").remove()
  $("style").remove()
  $("head").append("<title data-type='preview'>[" + gon.device + "] " + data.page.title + "</title>")

  $("head").prepend($(data.page.layout_head).attr('data-type', 'preview'))
  $("head").prepend($(data.page.settings.head).attr('data-type', 'preview'))

  reload_page_css(data)

  $("body").html(data.page.settings.body)

  $("head").append('<script data-type="preview" src="/assets/pages.js" type="text/javascript"></script>')

  $.log data, 'data,,,'
  reload_page_js(data)

reload_page_css = (data) ->
  false unless data
  if data.page.settings.lessable == '1'
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/css/layout/default.less")
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/css/layout/" + gon.device + ".less")
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/default.less")
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/" + gon.device + ".less")
    include_less();
  else
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/css/layout/default.css")
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/css/layout/" + gon.device + ".css")
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/default.css")
    append_css(data.page.snippet_id + '/pages/' + data.page.id + "/" + gon.device + ".css")

append_css = (file) ->
  $.log gon
  if gon.data.page.settings.lessable == '1'
    $("head").append("<link rel='stylesheet/less' href='" + host + "/books/" + file + "' data-type='preview' />")
  else
    $("head").append("<link rel='stylesheet' href='" + host + "/books/" + file + "' data-type='preview' />")

reload_page_js = (data) ->
  $("head").append("<script data-type='preview' src='" + data.page.id + "/js/layout/default.js'></script>")
  $("head").append("<script data-type='preview' src='" + data.page.id + "/js/default.js'></script>")
  # $("head").append("<script data-type='preview' src='" + data.page.id + ".js'></script>")

include_less = ->
  $("head").append("<script data-type='preview' src='http://cdnjs.cloudflare.com/ajax/libs/less.js/1.3.0/less-1.3.0.min.js'></script>")  
