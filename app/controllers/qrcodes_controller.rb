class QrcodesController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    respond_to do |format|
      # @text = params[:text] || request.url
      if @text = params[:text]
        format.html { render :qrcode => @text}
        format.svg { render :qrcode => @text }
        format.png { render :qrcode => @text }

        format.gif { render :qrcode => @text }
        format.jpg { render :qrcode => @text }
        format.jpeg { render :qrcode => @text }
        format.js {}
      else
        format.html {}
      end
    end
  end

  def lib
    respond_to do |format|
      gon.host = Settings.full_host
      format.js{}
    end
  end

  #  def new
  #    respond_to do |format|
  #      text = params[:text] || request.url
  #      format.html { render :qrcode => text }
  #      format.svg { render :qrcode => text }
  #      format.png { render :qrcode => text }
  #    end
  #  end
end
