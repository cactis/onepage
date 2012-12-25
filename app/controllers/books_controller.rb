# -*- encoding : utf-8 -*-
class BooksController < ApplicationController
    skip_before_filter :authenticate_user!, :only => [:index, :show]

  def index
    @books = Book.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/new
  # GET /books/new.json
  def new
    @book = current_user.books.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
  end

  # POST /books
  # POST /books.json
  def create
    @book = current_user.books.new(params[:book])

    respond_to do |format|
      if @book.save
        format.html { redirect_to edit_book_path(@book), notice: 'Book was successfully created.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @book = Book.find(params[:id])

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @book = current_user.books.find_by_id(params[:id])
      @book.destroy
      respond_to do |format|
        format.html { redirect_to root_url, :notice => "己成功刪除 #{@book.title}。" }
      end
    else
      redirect_to root_url, :notice => '只有作者本人才能刪除。'
    end
  end
end
