# -*- encoding : utf-8 -*-
class CommentsController < ApplicationController

  def index
    @page = Page.find(params[:page_id])
    @comments = @page.root_comments.order('created_at desc')
    @comment = @page.root_comments.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  def new
    @page = Page.find(params[:page_id])
    @comment = @page.comment_threads.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  def edit
    @page = Page.find(params[:page_id])
    @comment = current_user.comments.find(params[:id])
  end

  def create
    @commentable = Page.find(params[:page_id])
    @comment = Comment.build_from(@commentable, current_user.id, params[:comment][:body])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to page_comments_path(@commentable), notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comment = current_user.comments.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        @commentable = @comment.commentable
        format.html { redirect_to page_comments_path(@commentable), notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to page_comments_path(@comment.commentable), :notice => '己刪除留言。'}
      format.json { head :no_content }
    end
  end
end
