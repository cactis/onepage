# -*- encoding : utf-8 -*-
class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @pages = Page.page(params[:page])
  end

end
