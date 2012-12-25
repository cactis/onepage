$(document).ready ->
  $container = $("#preview_container")
  $container.css 'height', window.innerHeight - $container.position().top - 20
