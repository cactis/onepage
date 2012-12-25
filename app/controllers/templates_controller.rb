# -*- encoding : utf-8 -*-
class TemplatesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def index
    @templates = Template.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @templates }
    end
  end

  def show
    @template = Template.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @template }
    end

  end

  def new
    @template = Template.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @template }
    end
  end

  def edit
    @template = Template.find(params[:id])
  end

  def create
    @template = Template.new(params[:template])

    respond_to do |format|
      if @template.save
        format.html { redirect_to(edit_template_path(@template), :notice => 'Template was successfully created.') }
        format.xml  { render :xml => @template, :status => :created, :location => @template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @template.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    ap params
    @template = Template.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:template])
        format.html { redirect_to(edit_template_path(@template), :notice => 'Template was successfully updated.') }
        format.xml  { head :ok }
        format.js {
          render :update do |page|
            # page << "alert('Template was successfully updated.');"
          end
        }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @template.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.html { redirect_to(templates_url) }
      format.xml  { head :ok }
    end
  end
end

