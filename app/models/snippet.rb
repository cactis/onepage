# -*- encoding : utf-8 -*-
class Snippet < ActiveRecord::Base
  # versioned
  acts_as_commentable

  default_scope :order => 'updated_at desc'
  belongs_to :user

  attr_accessor :to_clone

  def title
    self[:title].present? ? self[:title] : '(未命名)'
  end

  def description
    self[:description].present? ? self[:description] : '(未提供說明)'
  end

  def summary
    return unless description
    description.truncate(150 + rand(300 - 150))
  end
end
