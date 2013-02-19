
$(document).ready ->

  $('#fork_btn').click ->
    $.ajax
      url: '/pages/' + gon.data.page.id
      type: 'put'
      data:
        fork: true
        page:
          id: gon.data.page.id
    false

  $('#movepage_btn a').click ->
    $.ajax
      url: '/pages/' + gon.data.page.id
      type: 'put'
      data:
        page:
          id: $(this).data('page-id')
          snippet_id: $(this).data('book-id')
    false


  $('#layout_id').click ->
    $.ajax
      url: '/pages/' + gon.data.page.id
      type: 'put'
      data:
        page:
          id: gon.data.page.id
          layout_id: $(this).val()
    false

  $('#request_body').click ->
    url = $('#page_body_from_url').val()
    $.ajax
      url: '/parses'
      type: 'post'
      data:
        url: url
      success: (data) ->
        $('#page_body').val(data)
    false


  # -------------- libraries ----------------------------
  $('.libraries input[type=checkbox]').click ->
    libraries = []
    $.each $('.libraries input[type=checkbox]'), (index, item) ->
      libraries.push $(item).attr('id') if $(item).prop('checked')
    $.log libraries
    $.ajax
      url: '/pages/' + gon.data.page.id
      type: 'put'
      data:
        page:
          libraries: libraries.join(';')

  if gon.data.page.settings.libraries
    $.each gon.data.page.settings.libraries.split(';'), (index, item) ->
      $('.libraries #' + item).prop('checked', true)

  # --------------- lessable ---------------------------
  $('#lessable').click ->
    $.ajax
      url: '/pages/' + gon.data.page.id
      type: 'put'
      data:
        page:
          id: gon.data.page.id
          lessable: if $(this).prop('checked') then '1' else '0'


  $('#lessable').prop('checked', if gon.data.page.settings.lessable == '1' then true else false )
