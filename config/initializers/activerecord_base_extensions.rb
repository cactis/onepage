# -*- encoding : utf-8 -*-
class ActiveRecord::Base
  before_create :maintain_onwer
  def maintain_onwer
    if self.has_attribute?(:user_id)
      self.user_id = User.current.id if User.current
    end
  end

  def save_without_timestamping
    class << self
      def record_timestamps; false; end
    end
    save
    class << self
      def record_timestamps; super ; end
    end
  end

end

def self.debug(*args)
  return unless Rails.env = "development"
  title ||= ""
  logger.ap '-' * 20 + calling_method + '-' * 20
  logger.ap args
  logger.ap '-' * 100
end

def debug(*args)
  return unless Rails.env = "development"
  title ||= ""
  logger.ap '-' * 20 + calling_method + '------ in model'
  logger.ap args
  logger.ap '-' * 100
end
