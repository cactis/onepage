document.write("<script src='http://onepage.fiterl.net/pages/361/js/default.js'></script>")
$('head').append("<link rel='stylesheet' href='http://onepage.fiterl.net/pages/361/css/default.css'/>")
$(document).ready ->
  imgs = [
    # 'images/apple.jpg',
    'http://slidking.fiterl.net/shots/aXECnhDnPKN1ZrqkBiSY_8286_o.jpeg',
    'http://slidking.fiterl.net/shots/7v61uoRrXfvrXJe6FtXu_8278_o.jpeg',
    'http://slidking.fiterl.net/shots/tV2Mhxy7HCe1qVdsjJgy_8263_o.jpeg',
    'http://slidking.fiterl.net/shots/ZqqsvKgrEteiewzmLeSg_8267_o.jpeg',
    'http://slidking.fiterl.net/shots/yvNr6xGUyUBVzPyeVzvD_8259_o.jpeg',
    'http://slidking.fiterl.net/shots/VrG7pBB93K8u34QMDpKp_6973_o.jpeg',
    'http://slidking.fiterl.net/shots/YRA8A9ZyvF37pcG2xP2o_8282_o.jpeg',
    'http://slidking.fiterl.net/shots/7v61uoRrXfvrXJe6FtXu_8278_o.jpeg',
    'http://slidking.fiterl.net/shots/ZqqsvKgrEteiewzmLeSg_8267_o.jpeg'
  ]
  $.gallery '#gallery-player', imgs
