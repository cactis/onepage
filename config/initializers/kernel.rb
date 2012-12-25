# -*- encoding : utf-8 -*-
module Kernel
  private
  def this_method
    caller[0] =~ /`([^']*)'/ and $1
  end
  def calling_method
    caller[1] =~ /`([^']*)'/ and $1
  end

  def debug(*args)
    return unless Rails.env = "development"
    title ||= ""
    ap '-' * 20 + calling_method + '-' * 20
    ap args
    ap '-' * 20
  end
end
