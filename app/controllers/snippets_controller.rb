# -*- encoding : utf-8 -*-
class SnippetsController < ApplicationController

  def index
    @snippets = resources_name.classify.constantize.page(params[:page]).per(50)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show

    # @snippet = resources_name.classify.constantize.find(params[:id])
    @snippet = params[:id].to_i > 0 ? @snippet = Snippet.find(params[:id]) : Snippet.find_by_title(params[:id])
    respond_to do |format|
      format.html {
        case site_mode
        when 'display'
          render :action => site_mode, :layout => 'display'
        when 'lib'
          render :action => site_mode, :layout => false
        else
          if params[:versions_list]
            @versions = @snippet.versions.order("created_at desc")
            render :action => 'versions_list'
          else
            render :action => :show
          end
        end
      }

      format.js{
        render :action => "widget"
      }

#      format.pjs{
#        render :text => @snippet.content
#      }

    end
  end

  def new
    @snippet = resources_name.classify.constantize.new

    respond_to do |format|
      format.js {
        render(:update) do |page|
          page.replace_html('drafter', render("snippets/new"))
        end
      }
      format.html
    end
  end

  def edit
    #@snippet = resources_name.classify.constantize.find(params[:id])
    @snippet = params[:id].to_i > 0 ? @snippet = Snippet.find(params[:id]) : Snippet.find_by_title(params[:id])
    redirect_to root_path unless can_edit?(@snippet)
  end

  def create
    return unless current_user
        package = params[resources_name.singularize.to_sym]
    @snippet = eval("current_user.#{resources_name}.new(package)")
    respond_to do |format|
      if @snippet.save
        format.html { redirect_to(polymorphic_path([:edit, @snippet]), :notice => 'snippet was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    package = params[resources_name.singularize.to_sym]
    @snippet = resources_name.classify.constantize.find(params[:id])
    respond_to do |format|
      if package[:to_clone] == "1"
        if @snippet = eval("current_user.#{resources_name}.create!(package)")
          format.html { redirect_to polymorphic_path([:edit, @snippet]), :notice => "已另建一筆新記錄"}
          format.js{
            render :update do |page|
              page << "window.location = '#{edit_polymorphic_path(@snippet)}'"
            end
          }
        else
          format.html { render :action => "edit", :notice => "無法另存新記錄"}
          format.js{}
        end
      else
        if @snippet.update_attributes(package)
          format.html { redirect_to( polymorphic_path([:edit, @snippet]), :notice => 'snippet was successfully updated.') }
          format.js{
            render :update do |page|
              if @snippet.is_a?(Jspice)
                # page.replace_html "jspice", @snippet.content
                # page << "notice('「#{@snippet.title}」已更新。');"
                # page << "$('.noSelect').disableTextSelect();"
              else
                page << "$('#iframe').attr('src', $('#iframe').attr('src'))"
              end
            end
          }
        else
          format.html { render :action => "edit" }
          format.js{}
        end
      end
    end
  end

  def destroy
    @snippet = resources_name.classify.constantize.find(params[:id])
    if @snippet.user == current_user
      @snippet.destroy
      redirect_to eval("#{resources_name}_path"), :notice => 'Has deleted it!'
    else
      redirect_to root_url
    end
  end
end
