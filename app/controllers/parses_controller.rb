class ParsesController < ApplicationController
  def create
    url = params[:url]
    data = Parse.new.request(url)
    render :text => data
  end
end
