# -*- encoding : utf-8 -*-
class Book < Snippet
  # attr_accessible :title, :body
  has_many :pages, :foreign_key => :snippet_id, :dependent => :destroy
end
