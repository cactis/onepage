//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.9.1.custom/js/jquery-ui-1.9.1.custom.min

//= require jquery/jquery.taboverride-1.0

//= require twitter/bootstrap

//= require default

notice = (msg) ->
  $notice = $("#notice")
  $notice.fadeIn(3000).html(msg).delay(30000).fadeOut 3000

# Set desired tab- defaults to four space softtab
checkTab = (evt) ->

  #$(function(){
  #$.extend($.fn.checkTab = function() {
  t = evt.target
  ss = t.selectionStart
  se = t.selectionEnd

  # Tab key - insert tab expansion
  if evt.keyCode is 9
    evt.preventDefault()

    # Special case of multi line selection
    if ss isnt se and t.value.slice(ss, se).indexOf("\n") isnt -1

      # In case selection was not of entire lines (e.g. selection begins in the middle of a line)
      # we ought to tab at the beginning as well as at the start of every following line.
      pre = t.value.slice(0, ss)
      sel = t.value.slice(ss, se).replace(/\n/g, "\n" + tab)
      post = t.value.slice(se, t.value.length)
      t.value = pre.concat(tab).concat(sel).concat(post)
      t.selectionStart = ss + tab.length
      t.selectionEnd = se + tab.length

    # "Normal" case (no selection or selection on one line only)
    else
      t.value = t.value.slice(0, ss).concat(tab).concat(t.value.slice(ss, t.value.length))
      if ss is se
        t.selectionStart = t.selectionEnd = ss + tab.length
      else
        t.selectionStart = ss + tab.length
        t.selectionEnd = se + tab.length

  # Backspace key - delete preceding tab expansion, if exists
  else if evt.keyCode is 8 and t.value.slice(ss - 4, ss) is tab
    evt.preventDefault()
    t.value = t.value.slice(0, ss - 4).concat(t.value.slice(ss, t.value.length))
    t.selectionStart = t.selectionEnd = ss - tab.length

  # Delete key - delete following tab expansion, if exists
  else if evt.keyCode is 46 and t.value.slice(se, se + 4) is tab
    evt.preventDefault()
    t.value = t.value.slice(0, ss).concat(t.value.slice(ss + 4, t.value.length))
    t.selectionStart = t.selectionEnd = ss

  # Left/right arrow keys - move across the tab in one go
  else if evt.keyCode is 37 and t.value.slice(ss - 4, ss) is tab
    evt.preventDefault()
    t.selectionStart = t.selectionEnd = ss - 4
  else if evt.keyCode is 39 and t.value.slice(ss, ss + 4) is tab
    evt.preventDefault()
    t.selectionStart = t.selectionEnd = ss + 4

#  })
#});
getDocHeight = ->
  D = document
  Math.max Math.max(D.body.scrollHeight, D.documentElement.scrollHeight), Math.max(D.body.offsetHeight, D.documentElement.offsetHeight), Math.max(D.body.clientHeight, D.documentElement.clientHeight)
$ ->
  $.extend $.fn.disableTextSelect = ->
    @each ->
      if $.browser.mozilla
        $(this).css "MozUserSelect", "none"
      else if $.browser.msie
        $(this).bind "selectstart", ->
          false

      else
        $(this).mousedown ->
          false



  $("#canvas").disableTextSelect()

tab = "  "
