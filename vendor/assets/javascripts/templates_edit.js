$(document).ready(function(){
  initial_toolset();
  initial_obj_at_editor($('#editor .obj'));
  $('#aside, #toolbar, #header').draggable();
  $('#editor').css('height', '600px');
})

function initial_toolset(){
  $('#toolset .obj').click(function(){
    var obj = $(this).clone();
    $('#editor').append(obj);
    initial_obj_at_editor(obj);
    obj.addClass('current');
    obj.css('padding', '1em');
  })
}

function initial_obj_at_editor(obj){
  obj.css('position', 'absolute');
  //obj.draggable({revert: true, containment: '#editor'});
  obj.draggable({containment: '#editor'});
  obj_resizable(obj);
  content_editable($('.content', obj));
}

$('#editor .obj').click(function(e){
  var $target = $(e.target);
  jQuery.each($('#editor .obj'), function(){
    $(this).css('z-index', $(this).css('z-index') - 10)
  })
  $target.css('z-index', 2147483637);
  //var font_size = $target.children('.content').css('font-size').replace('px', '');
  if ($('.content', $target).length > 0){
    var font_size = $('.content', $target).css('font-size').replace('px', '');
    $("#font_size_spinner").val(font_size);
  }
  var color = rgb2hex($target.children('.content').css('color'));
  var bcolor = $(this).css('backgroundColor');
  //var background_color = rgb2hex($target.children('.content').css('background-color'));
  $('#ForeColorSelector div').css('background-color', color);
  $('#BackgroundColorSelector div').css('backgroundColor', bcolor);
  $('#opacity_spinner').val(parseInt($(this).css("opacity") * 100));
  //$('#radius_spinner').val($(this).css('border-radius').replace('px', ''));
  $('#padding_spinner').val($(this).padding()["top"]);

  // update text_shadow_spinner
  var i = $('.content', $target).css('text-shadow');
  if ($('.content', $target).css('text-shadow')){
    i = i.split(' ');
    i = i[i.length -1].replace('px', '');
    $('#text_shadow_spinner').val(i);
  }
});

$('#ForeColorSelector').ColorPicker({
	color: '#00ffff',
	onShow: function (colpkr) {
		$(colpkr).fadeIn(300);
		return false;
	},
	onBeforeShow: function(){
	  if ($('.current .content').length > 0){
      $(this).ColorPickerSetColor(rgb2hex($('.current .content').css('color')));
    }
	},
	onHide: function (colpkr) {
		$(colpkr).fadeOut(300);
		return false;
	},
	onChange: function (hsb, hex, rgb) {
		$('#ForeColorSelector div').css('backgroundColor', '#' + hex);
		$('.current .content').css('color', '#' + hex);
	}
});


$('#BackgroundColorSelector').ColorPicker({
	color: '#00ffff',
	onShow: function (colpkr) {
		$(colpkr).fadeIn(300);
		return false;
	},
	onBeforeShow: function(){
	  if ($('.current .content').length > 0){
      $(this).ColorPickerSetColor(rgb2hex($('.current').css('backgroundColor')));
    }
	},
	onHide: function (colpkr) {
		$(colpkr).fadeOut(300);
		return false;
	},
	onChange: function (hsb, hex, rgb) {
		$('#BackgroundColorSelector div').css('backgroundColor', '#' + hex);
		$('.current').css('backgroundColor', '#' + hex);
	}
});


$('.background_image img').bind('click', function(){
  $('.current').css('background', 'url(' + $(this).attr('src') + ')');
})

$('.border_image img').bind('click', function(){
  $('.current').css('-webkit-border-image', 'url(' + $(this).attr('src') + ')');
})

$('#editor').click(function(e) {
  var $target = $(e.target);
  $('.current').removeClass('current');
  $target.addClass('current');
});

$("#font_size_spinner").click(function(){
  $('.current .content').css('font-size', $(this).val() + 'px');
}).change(function(){ $('.current .content').css('font-size', $(this).val() + 'px');});


$("#opacity_spinner").bind('click', function(){
  opacity_spinner($('.current'), $(this).val(), $('.current').css('background-color').replace('rgb(', '').replace(')', ''));
}).change(function(){ opacity_spinner($('.current'), $(this).val()) })

$("#radius_spinner").click(function(){
  radius_spinner($('.current'), $(this).val());
}).change(function(){ radius_spinner($('.current'), $(this).val()); })

$("#padding_spinner").click(function(){
  padding_spinner($('.current'), $(this).val());
}).change(function(){ padding_spinner($('.current'), $(this).val()); })

$("#text_shadow_spinner").click(function(){
  text_shadow_spinner($('.current .content'), $(this).val());
}).change(function(){ text_shadow_spinner($('.current .content'), $(this).val()); })

$('form :submit').hover( function(){
    $('.obj').resizable("destroy");
    $('.current').removeClass('current');
    $('#editor').css('z-index', -2147483647);
    //$('.content').trigger('cancel');
  },
  function(){
    obj_resizable($(".obj"));
  }
)

function content_editable(obj){
  obj.editable(
    { type: 'textarea',
      submit: 'save',
      cancel: 'cancel'
    }
  );
}

function obj_resizable(obj){
  obj.resizable(
    { autoHide: true,
      //animate: true,
      //animateDuration: 100,
      //animateEasing: 'swing',
      ghost: true,
      handles: 'n, e, s, w, ne, se, sw, nw',
      helper: 'ui-state-highlight',
      stop: function(){
      }
    }
  )
}

//$("#accordion").accordion({header: 'h2'});

$("#editor").droppable({
  drop: function(ev, ui){
    $(this).append($(ui.draggable));
    //var $target = ev.target;
    //$target.append($(ui.draggable));
    $(ui.draggable).draggable({revert: false});
  }
})


//Function to convert hex format to a rgb color
var hexDigits = new Array
        ("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");

function rgb2hex(rgb) {
  if (rgb){
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    if (rgb == null){ rgb = [0, 0, 0] }
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
  }
}

function hex(x) {
  return isNaN(x) ? "00" : hexDigits[(x - x % 16) / 16] + hexDigits[x % 16];
 }


function opacity_spinner(obj, value, color){
  var o_value = value / 100;
  obj.css("background-color", "rgba(" + color + ', ' + o_value + ")");

  obj.css("filter", "alpha(opacity=" + value + ")");
  obj.css("-moz-opacity", o_value);
  obj.css("-khtml-opacity", o_value);
  obj.css("opacity", o_value);

  var content = $('.content', obj);
  if (content.length > 0){
    opacity(content, 100);
  }
}

function radius_spinner(obj, value){
  obj.css('-webkit-border-radius', value + 'px');
  obj.css('-moz-border-radius', value + 'px');
  obj.css('border-radius', value + 'px');
}

function padding_spinner(obj, value){
  obj.css('padding', value + 'px');
}

function text_shadow_spinner(obj, value){
  var color = rgb2hex(obj.css('color'));
  color = $.xcolor.complementary(color);
  value = color + ' ' + value + 'px ' + value + 'px '+ value + 'px';
  obj.css('text-shadow', value);
}

function hex2rgb(hex) {
  var toDec = function(v) {
    switch(v) {
      case 'a': case 'A': return 10;
      case 'b': case 'B': return 11;
      case 'c': case 'C': return 12;
      case 'd': case 'D': return 13;
      case 'e': case 'E': return 14;
      case 'f': case 'F': return 15;
      default: return parseInt(v);
    }
  };
  var r = 0, g = 0, b = 0;
  if( hex.match(/^#([0-9A-Fa-f]){3}$|([0-9A-Fa-f]){6}$/) ) { // regex handles length checks
    var s = hex.replace(/#/,'');
    if( s.length == 3 ) {
      r = toDec(s.substring(0,1));
      g = toDec(s.substring(1,2));
      b = toDec(s.substring(2,3));

      r = (r*16) + r;
      g = (g*16) + g;
      b = (b*16) + b;
    }
    else {
      r = toDec(s.substring(0,1));
      var rr = toDec(s.substring(1,2));
      g = toDec(s.substring(2,3));
      var gg = toDec(s.substring(3,4));
      b = toDec(s.substring(4,5));
      var bb = toDec(s.substring(5,6));

      r = (r*16) + rr;
      g = (g*16) + gg;
      b = (b*16) + bb;
    }
  }

  return {r:r,g:g,b:b};
}




//////////////////////////////////
$('#editor .obj_xxxxxxxxxxxxxx').draggable({
  drag: function(event, ui){
    var rotateCSS = 'rotate(' + ui.position.left + 'deg)';
    $(this).css({
      '-moz-transform': rotateCSS,
      '-webkit-transform': rotateCSS
    });
  }
});

