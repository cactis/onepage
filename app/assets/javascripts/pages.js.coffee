$(document).ready ->
  $('body').append("<div id='back_to_home'><a href='/' title='回首頁'><span id='t'></span><i class='icon-home'></i></a>" + "<a href='/pages/" + gon.data.page.id + "/comments' title='留言板'><i class='icon'>O</i> (" + gon.data.page.comments_count + ")</a>" + "<a href='/books/" + gon.data.page.snippet_id + "/pages/" + gon.data.page.id + "/edit' title='編輯/查看原始碼'><i class='icon-pencil'></i></a><a href='#' id='onepage-grids-btn' title='顯示排版格線'><i class='icon-th'></i></a></div>")

  if window.location.hash
    $('#tabs li').removeClass('active')
    $('#tabs [href=' + window.location.hash + ']').closest('li').addClass('active')


  # 在 refresh 時有問題
  if $('#tabs a').length > 0
    $('#tabs a').click ->
      id = $(this).attr('href')
      console.log id
      history.pushState null, null, id
      $('.tab-pane').css 'display', 'none'
      $(id).css('display', 'block')

    $('#tabs a-xxxxxx').click ->
      id = $(this).attr('href')
      top = $(id).position().top
      history.pushState null, null, id
      $('.tab-container').animate
        'top': -1 * top
      ,
        duration: 300
        easing: 'easeOutExpo'

  $(window.location.hash).css 'display', 'block'

  $('.dropdown-toggle').click ->
    $dn = $(this).next()
    $dn.css 'left', $(this).offset().left - 16
    $dn.css 'top', $(this).offset().top + $(this).height() + 4
    $dn.fadeIn()
    $.log 'dropdown-toogle: click'
    false

  $('.dropdown-menu a').click ->
    $('.dropdown-menu').fadeOut()
  $('body').click ->
    $('.dropdown-menu').fadeOut()



  # 960 grids
  $('head').append("<script src='" + gon.production_url + "/pages/269/js/default.js'></script>")

  # $.auto_external_link()
  $('body').append("<script src='/assets/qrcodes_lib.js'></script>")

  #prev, next navigator
#  left = 0
#  $('body').animate
#    left: -1 * left
#  ,
#    duration: 5500
#    easing: 'easeOutExpo'

  if gon.next_id
    $('body').append("<a id='next_page' class='icon-chevron-right' href='/pages/" + gon.next_id + window.location.search + "'></a>")

    $('body #next_page1').remove()
    $('#next_page1').click ->
      left = 2000
      $('body').css('position', 'absolute').animate
        left: -1 * left
      ,
        duration: 5500
        easing: 'easeOutExpo'

      $('html').load('/pages/' + gon.next_id)

      false
      $.ajax
        url: '/pages/' + gon.next_id
        success: (data) ->
          test(data, 'next')
      false

  if gon.prev_id
    $('body').append("<a id='prev_page' class='icon-chevron-left' href='/pages/" + gon.prev_id + window.location.search + "'></a>")
    $('body #prev_page1').remove()

    $('#prev_page1').click ->
      $('html').load('/pages/' + gon.prev_id)
      false

      $.ajax
        url: '/pages/' + gon.prev_id
        success: (data) ->
          test(data, 'prev')
      false

test = (data, direction) ->
  left = if direction == 'next' then 2000 else 0
  $('body').css('position', 'absolute').animate
    left: -1 * left
  ,
    duration: 5500
    easing: 'easeOutExpo'
  $('html').html('').append(data)
  false

$(window).resize ->
  if $("#about_screen_size").length > 0
    $("#about_screen_size").html($(this).width() + 'x' + $(this).height())
  else
    $("body").append("<div id='about_screen_size'></div>")
    $("#about_screen_size").html($(this).width() + 'x' + $(this).height())

$.extend auto_external_link: ->
  $("a.external").each ->
    $(this).attr "target", "_blank"
  $("a[href^='http']").each ->
    $(this).attr "target", "_blank"  if @href.indexOf(location.hostname) == -1


$(document).ready ->
  # html2haml onfly convert
  $("#btn_html_to_haml").click ->
    $.ajax
      url: '/converters/html2haml'
      data: $('#page_body')
      type: 'post'
      success: (data, textStatus, jqXHR) ->
        $.log data
      complete: (data) ->
        html = data.responseText
        $.log html
        $("#page_body").val(html)
    false

  $("textarea").keyup (e) ->
    ew = e.which
    return true  if ew is 32
    return true  if 16 <= ew and ew <= 45
    return true  if 91 <= ew and ew <= 93
    return true  if 112 <= ew and ew <= 123
    return true  if 144 <= ew and ew <= 145
    $(this).addClass('dirty')
    $.log 'dirty'
    false


  config = "top=0,left=0,resizable=yes,scrollbars=yes,toolbar=1,location=1,"

  $('#open_desktop_screen').click ->
    window.open("/pages/" + gon.page_id + '?device=desktop', 'Desktop_Screen', config + 'width=1024,height=768')
    false

  $('#open_tablet_devices').click ->
    window.open("/pages/" + gon.page_id + '?device=tablet', 'Tablet_Screen', config + 'width=600,height=700')
    false

  $('#open_mobile_devices').click ->
    window.open("/pages/" + gon.page_id + '?device=mobile', 'Mobile_Screen', config + 'width=380,height=500')
    false

  $('#open_print_devices').click ->
    window.open("/pages/" + gon.page_id + '?device=print', 'Print_Device', config + 'width=1024,height=768')
    false

  $('#open_page_show').click ->
    windowFeatures = config + "width=" + (screen.width - 100) + ",height=" + (screen.height - 100)
    window.open("/pages/" + gon.page_id, 'Page_Show', windowFeatures)
    false

  $("textarea").tabOverride().attr('wrap', 'off')


#$(window).resize ->
#  $.log $(window).innerHeight()
#  h = if $(window).innerHeight() - 400 > 100 then $(window).innerHeight() - 400 else 100
#  h = if $(window).innerHeight() > 100 then $(window).innerHeight() - 300 else 100
#  $('textarea').css 'height', h

isCtrl = false
$(document).keydown (e) ->
  isCtrl = true  if e.which is 17
  if e.which is 83 and isCtrl is true
    # isCtrl = false
    $("form").submit()
    false
  else

$(document).keyup (e) ->
  if e.which is 17
    isCtrl = false
