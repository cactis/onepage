# -*- encoding : utf-8 -*-
class Page < Snippet
  # attr_accessible :title, :body
  belongs_to :book, :foreign_key => :snippet_id
  belongs_to :fork, :class_name => 'Page'
  belongs_to :layout, :class_name => 'Page'

  has_many :forks, :foreign_key => 'fork_id', :class_name => 'Page'#, :dependent => :nullify
  has_many :layouts,:foreign_key => 'layout_id', :class_name => 'Page'#, :dependent => :nullify

  store :settings, :accessors => [:head, :body, :default, :desktop, :tablet,
      :mobile, :print, :script, :lessable, :libraries, :body_from_url]

  libraries =   ["lesselements", "semanticgs", "prebootless", "bootstrap", "lesshat"]

  def layout_head
    head = []
    if self.layout
      head << self.layout.layout_head
      head << self.layout.head
    end
    head.join
  end

  def previous
    Page.unscoped.order('id').where(["snippet_id = ? and id < ?", self.book.id, self.id]).last
  end

  def next
    Page.unscoped.order('id').where(["snippet_id = ? and id > ?", self.book.id, self.id]).first
  end

  def body_to_html
    raw = body.gsub('= yield', '{{yield}}')

    data = Haml::Engine.new(raw, :suppress_eval => true).render
    if self.layout
      data = self.layout.body_to_html.gsub('= yield', data)
    end
    data = data.gsub('{{yield}}', '= yield')
    return data
    rescue
#      begin
#        debug 'haml error'
#        data = RDiscount.new(raw).to_html
#        debug data, 'markdown'
#        data = data.gsub('{{yield}}', '= yield')
#        return data
#      rescue
        return raw
      #end

    #rescue => e
    #  begin
    #    ERB.new(data).result
    #  rescue => j
    #    return "錯誤: #{e.message}"
    #    #return data
    #  end
  end

  def layout_js
    js = []
    if self.layout
      js << self.layout.layout_js
      # js << "/* page #{self.id} -- layout js */"
      js << self.layout.script_to_js
    end
    js.join
  end

  def script_to_js
    js = CoffeeScript.compile script
    return js
    rescue => e
      return script
  end

  def layout_css(media)
    css = []
    if self.layout
      css << self.layout.layout_css(media)
      css << "/* page #{self.id} -- #{media} css */"
      css << eval("self.layout.#{media}_to_css")
    end
    css.join("\n")
  end

  def layout_less(media)
    css = []
    if self.layout
      css << self.layout.layout_less(media)
      css << "/* page #{self.id} -- #{media} less */"
      css << eval("self.layout.#{media}_to_less")
    end
    css.join("\n")
  end


  libraries.each do |mixin|
    class_eval %(
      def #{mixin}?
        return false unless libraries
        return libraries.split(';').index("#{mixin}") ? true : false
      end
    )
  end

  %w[default desktop tablet mobile print].each do |media|
    class_eval %(
      def #{media}_to_less
        raw = #{media}
        data = include_libraries(raw)
        return data
      end
    )
  end

  def include_libraries(data)
    data = File.read("#{Rails.root}/vendor/assets/stylesheets/extra.less") + data
    data = File.read("#{Rails.root}/public/stylesheets/elements.less") + data if lesselements?
    data = File.read("#{Rails.root}/vendor/assets/stylesheets/LESSHat/lesshat.less") + data if lesshat?
    data = File.read("#{Rails.root}/vendor/assets/stylesheets/Preboot.less/bootstrap.less") + data if prebootless?
    data = File.read("#{Rails.root}/vendor/assets/stylesheets/semantic.gs/stylesheets/less/grid.less") + data if semanticgs?
    data = load_bootstrap + data if bootstrap?
    return data
  end

  def load_bootstrap(rebuild = false)
    path = "#{Rails.root}/vendor/assets/stylesheets/bootstrap/less"
    target = "#{path}/bootstrap-all.less"
    # return File.read(target) if (File.exists?(target) && !rebuild)

    tmp = Tempfile.new('bootstrap')
    # ap File.read("#{path}/bootstrap.less")
    i = 0
    File.read("#{path}/bootstrap.less").each_line do |line|
      # next if i >= 1
      if line =~ /^\@import.*\n/
        i += 1
        file = line.match(/[a-z.-]*.less/)[0]
        ap file
        # ap File.read("#{path}/#{file}")
        tmp.print File.read("#{path}/#{file}")
      end
    end
    # tmp.flush
    tmp.rewind
    data = tmp.read
    tmp.close
    tmp.unlink
    f = File.new(target, 'w')
    f.write data
    # parser = Less::Parser.new
    # data = parser.parse(File.read(target)).to_css
    return data
    # return data
  end

  %w[default desktop tablet mobile print].each do |media|
    class_eval %(
      def #{media}_to_css
        raw = #{media}
        data = include_libraries(raw)
        # data = LessJs.compile(data)
        parser = Less::Parser.new
        data = parser.parse(data).to_css
        return data
        rescue => e
          begin
            data = Sass::Engine.new(raw).render
            return data
          rescue => j
            begin
              data = Sass::Engine.new(raw, :syntax => :scss).render
              return data
            rescue => k
              return raw
            end
          end
      end
    )
  end
end


# data = LessJs.compile(raw)
# data = ExecJS.compile(raw)
# data = Tilt::LessTemplate.new().render

# parser = Less::Parser.new(:path => ['/home/ctslin/Dropbox/www/onepage/public/stylesheets/elements.less'])
# data = parser.parse(raw).to_css

# parser = Less::Parser.new :paths => ['./lib', './public/stylesheets'], :filename => 'elements.less'
# data = parser.parse(raw).to_css
