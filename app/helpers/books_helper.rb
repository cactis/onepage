# -*- encoding : utf-8 -*-
module BooksHelper
  def link_to_new_page(book)
    link_to "<i class='icon'>F</i>New Page".html_safe, new_book_page_path(@book), :class => 'btn btn-primary'
  end
end
