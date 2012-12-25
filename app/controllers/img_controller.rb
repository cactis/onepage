# -*- encoding : utf-8 -*-

class ImgController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    return unless params[:size]
    debug params[:size], 'params[:size]'
    opts = {}
    _params = "size=#{params[:size]}".split('&').map{|t| t.split('=')}.each{|t| opts[t[0]] = t[1]}

    w, h = opts["size"].split('x').map{|s| s.to_i}
    text = opts["text"] || "#{w}x#{h}"

    color = "##{opts['color'] || '666'}"
    font_size = opts['font-size']

    code = 191
    background_color = opts['background-color'] ? opts['background-color'].split(',').map{|s| s.to_i} : [code, code, code, 200]
    background_color = ChunkyPNG::Color.rgba(*background_color)

    png = ChunkyPNG::Image.new(w, h, background_color)#ChunkyPNG::Color::TRANSPARENT)
    # png[100, 100] = ChunkyPNG::Color.rgba(10, 20, 30, 128)
    # png[222, 122] = ChunkyPNG::Color('black @ 0.5')
    # png[222, 200] = ChunkyPNG::Chunk::Text.new(rgba(0, 0, 0, 100), 'abc')
    # file = "#{Rails.root}/tmp/filename.png"
    f = Tempfile.new('flyimg')
    file = f.path
    png.save(file, :interlace => true)



    file = draw_text file, text, color, font_size

    f.rewind

    # system("convert pattern:hexagons xc: +noise Random #{file} ")
    # system("convert xc:white -fill '#cc0000' -opaque white #{file}")

    # file.read      # => "hello world"
    send_file file, :disposition => 'inline', :type => 'image/png'#, :x_sendfile => true
    f.close
    f.unlink
  end

  def draw_text(file, text, color, font_size)
    # font = "fireflysung.ttf"
    font = "wqy-microhei.ttc"
    # text = "text 0, 0 '`piconv -f utf8 -t utf8 -s '#{text}'`'"
    # convert -pointsize 72 -fill white -font fireflysung.ttf -size 500x200 xc:black -draw "text +20+100 '`piconv -f big5 -t utf8 -s '中國'`'" chinese.jpg
    img = MiniMagick::Image.from_file(file)
    # return file unless img[:width] > 100
    # img.format = 'gif'

    img.combine_options do |c|
      c.gravity 'center' #Southwest'
      c.font Rails.root.join("vendor/fonts/#{font}").to_s# + " label:#{text.force_encoding('utf-8')}"
      c.pointsize get_font_size(img, font_size, text)
      text = "text 0, 0 '#{text.force_encoding('utf-8')}'"
      c.draw text
      c.fill(color)
      c.encoding "UTF-8"
      # file = file.gsub('.png', '.gif')
      c.write file

    end
    file
  end

  def get_font_size(img, font_size, text)
    return font_size if font_size
    font_size = ([img[:width], img[:height] > 100 ? 100000 : img[:height]].min / 10).to_s
    debug font_size, '1111111111'
    debug img[:width], 'img[:width]'
    debug text, 'text'

    #    font_size = [font_size.to_i, img[:width] / text.length].min.to_s
    #    debug font_size, '2222222222'
    return font_size
  end
end
