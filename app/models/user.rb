# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  extend UserExtend
  extend OmniauthCallbacks
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :oauthable
#  devise :database_authenticatable, :registerable,
#         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
#  attr_accessible :email, :password, :password_confirmation, :remember_me

  devise :database_authenticatable, :registerable, #:confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable#, :oauthable#, :encryptable, :token_authenticatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :nickname, :blog, :description, :notified, :confirmed_at, :confirmation_token,
    :sign_in_from, :sign_up_from, :blog, :gender

  has_many :snippets, :dependent => :destroy

  has_many :books
  has_many :pages

  has_many :comments

  has_many :templates
  has_many :scratches
  has_many :jspices
  has_many :jslibs

  def title
    username
  end

  def username; email.split('@')[0]; end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_google_apps_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']# ['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_twitter_apps_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']# ['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end

#  acts_as_configurable do |c|
#    c.string :prev_read, :default => ""
#    c.integer :paper_category_id, :default => nil
#    c.string :paper_location
#    c.integer :paper_quantity
#    c.string :top_tags
#    c.string :blog
#    c.string :top_tags_time
#    c.integer :font_size, :default => 40
#    c.string :sign_up_from, :default => 'Xuelele'
#    c.string :sign_in_from, :default => 'Xuelele'
#    c.string :gender
#    c.string :facebook_id
#    c.boolean :certified
#    c.string :official_title
#    c.string :emails_list, :default => ""
#  end

# def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
#    data = ActiveSupport::JSON.decode(access_token.get('https://graph.facebook.com/me?'))
#    if user = User.find_by_email(data["email"])
#      user.confirmed_at = Time.now
#      user.confirmation_token = nil
#      user.facebook_id = data['id']
#      user.sign_in_from = 'Facebook'
#      user.blog = data['website'] || data['link'] if !user.blog.present?
#      user.gender = data['gender']
#      user.save_without_timestamping
#      user
#    else # Create an user with a stub password.
#      User.create!( :email => data["email"],
#                    :password => Devise.friendly_token[0,20],
#                    :facebook_id => data['id'],
#                    :nickname => data['name'],
#                    :confirmed_at => Time.now,
#                    :confirmation_token => nil,
#                    :sign_up_from => 'Facebook',
#                    :sign_in_from => 'Facebook',
#                    :blog => data['website'] || data['link'],
#                    :gender => data['gender']
#                  )
#    end
#  end

end
