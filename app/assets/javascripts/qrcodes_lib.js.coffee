host = "http://onepage.airfont.com"

$(document).ready ->
  $('body').append("<div id='onepage_qr_code'><a href='#' id='qrcode-btn' style='font-size: 20px; padding: 6px; display: inline-block; color: white'><i class='icon-qrcode'></i></a>")

  $('#qrcode-btn').click ->
    # $("#back_to_home").fadeOut()
    href = window.location.href
    img = "<div id='qrcode'><div id='close'><i class='icon-remove'></i></div><img src='" + host + "/qrcodes.svg?text=" + href + "'/></div>"
    $('body').append(img)
    $(this).fadeOut()

    $("#close, #qrcode").unbind('click').click ->
      $("#qrcode-btn").fadeIn()
      $("#qrcode").fadeOut()
      $('#qrcode').remove()
      false
    false

$('head').append("<style>
  #onepage_qr_code{
    background-color: #000;
    position: fixed;
    right: 0;
    bottom: 10%;
  }
  #qrcode{
    cursor: pointer;
    position: fixed;
    background-color: #111;
    padding: 5px;
    border: 3px solid #ccc;
    right: 0;
    bottom: 0;
    z-index: 99;
    color: #fff;
  }
  #qrcode img{
    width: 160px;
    border: 10px solid #eee;
    background-color: #fff;
  }
  #qrcode #close{
    cursor: pointer;
  }
</style>")
