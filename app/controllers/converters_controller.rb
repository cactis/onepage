class ConvertersController < ApplicationController
  def html2haml
    respond_to do |format|
      format.js{
        raw = params[:page][:body]
        debug raw, 'raw'
        begin
          data = Haml::Engine.new(raw, :suppress_eval => true).render
          data = Haml::HTML.new(raw).render if raw == data
        rescue
          data = Haml::HTML.new(raw).render
        end
#        begin
#          data = Haml::Engine.new(raw).render
#          debug data, 'data as HTML'
#        rescue
#          data = Haml::HTML.new(raw).render
#          debug data, 'data as HAML'
#        end
        debug data, 'result'
        render :text => data.gsub('&amp;', '&')
      }
    end
  end

  def haml2html
  end
end
