/* DO NOT MODIFY. This file was compiled Fri, 15 Apr 2011 08:50:23 GMT from
 * /home/ctslin/www/onepage/app/coffeescripts/shorty.coffee
 */

(function() {
  $(document).ready(function() {
    var preview;
    preview = $("#preview-url");
    return $('#url_url').keyup(function() {
      var current_value;
      current_value = $.trim(this.value);
      if (current_value === '') {
        return preview.hide().attr('src', '');
      } else {
        return preview.show().attr('src', current_value);
      }
    });
  });
}).call(this);
