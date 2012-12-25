# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  def index
    @pages = Page.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  def show
    @page = Page.find(params[:id])
    gon.page_id = @page.id
    gon.data = @page
    gon.data[:layout] = @page.layout
    gon.data[:layout_head] = @page.layout_head
    gon.production_url = Settings.production_url
    gon.next_id = @page.next.id if @page.next
    gon.prev_id = @page.previous.id if @page.previous
    gon.data[:comments_count] = @page.comment_threads.count

    debug params[:slide]

    respond_to do |format|
      format.html {
        @page.settings[:body] = @page.body_to_html

        debug params[:device], 'params[:device]'
        if params[:device]
          gon.device = params[:device]
          render 'preview_device', :layout => false
        else
          debug 'show normal page'
          render :layout => false
        end
      }
      format.json { render json: @page }
      format.less {
        if params[:as] == 'layout'
          render :text => @page.layout_less(params[:media])
        else
          render :text => eval("@page.#{params[:media]}_to_less")
        end
      }
      format.css {
        if params[:as] == 'layout'
          render :text => @page.layout_css(params[:media])
        else
          render :text => eval("@page.#{params[:media]}_to_css")
        end
      }
      format.js{
        if params[:as]
          render :text => @page.layout_js
        else
          render :text => @page.script_to_js
        end
      }

      format.pdf {
        render  :pdf                    => "#{@page.title} [#{Time.now.strftime('%Y-%m-%d')}]",
                    :layout                         => 'pdf.html',
                    :wkhtmltopdf                    => "#{Rails.root}/bin/#{Rails.env}/wkhtmltopdf",
                    :show_as_html                   => params[:debug].present?,
                    :margin => {  :top              => 20,
                                  :bottom           => 20,
                                  :left             => 5,
                                  :right            => 5
                                },
                    :page_size => "A4",
                    :javascript_delay => 10000,
                    :header => {  :html => {
                                             :template => 'layouts/pdf_header'
                                           },
                                   :spacing => 10,
                                   :font_name          => "wqy-microhei",
                               },
                    :footer => {   :html => {
                                              :template => 'layouts/pdf_footer'
                                            },
                                    :spacing => 10
                                }
      }
    end
  end

  def new
    debug params
    @page = Book.find(params['book_id']).pages.new
    gon.data = @page
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  def edit
    @page = Page.find(params[:id])
    gon.page_id = @page.id
    gon.data = @page
    gon.production_url = Settings.production_url
    gon.page_id = @page.id
  end

  def create
    @page = current_user.pages.new(params[:page])
    respond_to do |format|
      if @page.save
        format.html { redirect_to edit_book_page_path(@page.book, @page), notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @page = Page.find(params[:id])
    params[:page][:layout_id] = params[:page][:layout].to_i if params[:page][:layout].present?
    move_to_another_book = true if @page.book && params[:page][:snippet_id] && @page.book.id != params[:page][:snippet_id].to_i

    if @page.user != current_user || params[:fork]
      fork = true
    else
      fork = false
    end

    if !fork
      respond_to do |format|
        if @page.update_attributes(params[:page])
          format.js{
            @page.settings[:body] = @page.body_to_html
            @page.settings[:script] = @page.script_to_js
            @page[:layout_head] = @page.layout_head
            @page['layout'] = @page.layout
            gon.data = @page
            if move_to_another_book
              render :js => "window.location.pathname = '" + edit_book_page_path(@page) + "'"
            end
            }
        else
          format.html { render action: "edit" }
        end
      end
    else
      @page = current_user.pages.new(@page.attributes)
      @page.save
      book = current_user.books.find_or_create_by_title('副本集')
      @page.update_attributes(params[:page].merge({:fork_id => params[:id], :snippet_id => book.id}))
      respond_to do |format|
        jscode = "window.location.pathname = '#{edit_book_page_path @page.book, @page}'"
        format.js { render :js => jscode}
      end
    end
  end

  def destroy
    if @page = current_user.pages.find_by_id(params[:id])
      @book = @page.book
      @page.destroy
      respond_to do |format|
        format.html { redirect_to edit_book_path(@book), :notice => "已成功刪除 #{@page.title}。" }
      end
    else
      redirect_to root_url, :notice => '只能刪除自己的頁面。'
    end

  end

  private
  def setlayout(page)
    page['layout'] = page.layout
  end
end
