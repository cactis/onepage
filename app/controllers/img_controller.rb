# -*- encoding : utf-8 -*-

class ImgController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    return unless params[:size]
    opts = {}
    _params = "size=#{params[:size]}".split('&').map{|t| t.split('=')}.each{|t| opts[t[0]] = t[1]}

    w, h = opts["size"].split('x').map{|s| s.to_i}
    text = opts["text"] || "#{w}x#{h}"

    color = "##{opts['color'] || '666'}"
    font_size = opts['font-size'] || '24'

    code = 191
    b_color = opts['background-color'] ? opts['background-color'].split(',').map{|s| s.to_i} : [code, code, code, 200]
    bg = ChunkyPNG::Color.rgba(*b_color)

    png = ChunkyPNG::Image.new(w, h, bg)
    tmpfile = Tempfile.new('tmpfile_')
    filename = tmpfile.path
    png.save(filename, :interlace => true)

    imgfile = draw_text filename, text, color, font_size
    tmpfile.rewind

    send_file imgfile, :disposition => 'inline', :type => 'image/png'
    # tmpfile.close
    # tmpfile.unlink
  end

  def draw_text(file, text, color, font_size)
    fontname = "wqy-microhei.ttc"
    image = MiniMagick::Image.from_file(file)

    image.combine_options do |img|
      img.gravity 'center'
      img.font Rails.root.join("vendor/assets/fonts/#{fontname}").to_s
      img.pointsize get_font_size(img, font_size, text)
      text = "text 0, 0 '#{text.force_encoding('utf-8')}'"
      img.fill(color)
      img.draw text
      img.encoding "UTF-8"
      img.write file
    end
    file
  end

  def get_font_size(img, font_size, text)
    return font_size if font_size
    font_size = ([img[:width], img[:height] > 100 ? 100000 : img[:height]].min / 10).to_s
    return font_size
  end
end
