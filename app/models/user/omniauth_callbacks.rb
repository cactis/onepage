# -*- encoding : utf-8 -*-
require 'open-uri'
class User
  module OmniauthCallbacks
    Settings.oauth_providers.split(', ').each do |provider|
      define_method "find_or_create_for_#{provider}" do |response|
        # assume that we've got a legal authorization from the remote user
        uid = response["uid"]
        info = response["info"]

        user = nil

        authorization = Authorization.where(:provider => provider, :uid => uid).first
        if authorization
          # remote user already authorized our website and registered as a user
          # just login the user
          user = authorization.user
        else
          # remote user authorized our website
          # but seems that the authorization is not stored in our website

          # find whether the user did registred with the same email in our website
          user = User.find_by_email(info["email"])
          if user
            # if the user is found, just login the user
            # and bind the authorization to that user
            user.bind_service(response)
          else
            # response has nothing to identify the user
            # could be a brand new user, logging in with 3rd party account
            user = User.new_from_provider_data(provider, uid, response)
            if user.save(:validate => false)
              user.bind_service(response)
            else
              Rails.logger.warn("3rd-party authentication failed，#{user.errors.inspect}")
            end
          end
        end

        return user
      end
    end

    def new_from_provider_data(provider, uid, response)
      # data = response["info"]
      debug response, 'response'
      data = response["info"]
      debug data, 'data'
      user = User.new
      user.email = data["email"]
      debug provider,'provider'

      if user.has_attribute?(:login)
        case provider
        #      when 'twitter'
        #        user.login = data["nickname"]
        #        user.email = "twitter+#{uid}@example.com"
        when "google"
          user.login = data["name"]
          user.avatar = open(data["image"]) if data["image"]
        when "facebook"
          user.login = data["name"]
          user.avatar = open(data["image"].sub("square","large")) if data["image"]
        when 'github'
          user.login = response["extra"]["raw_info"]['login']
          user.avatar = open(response["extra"]["raw_info"]["avatar_url"])
          user.email = "#{Devise.friendly_token}@#{Settings.domain}"
        end

        debug user.login, 'user.login'
        # user.login = user.login.gsub(/[^\w]/, "_")
        debug user.login, 'user.login'

        while User.find_by_login(user.login)
          user.login = "#{data["first_name"]}#{rand*10000.to_i} #{data["last_name"]}"
        end
      end

      user.password = Devise.friendly_token[0,20]
      user.location = data["location"]
      user.tagline = data["description"]
      user.first_name = data["first_name"]
      user.last_name = data["last_name"]

      return user
    end
  end

  def bind?(provider)
    self.authorizations.collect { |a| a.provider }.include?(provider)
  end

  def bind_service(response)
    provider = response["provider"]
    uid = response["uid"]
    authorization = authorizations.new(:provider => provider , :uid => uid)
    authorization.raw = response
    authorization.token = response.credentials.token
    authorization.refresh_token = response.credentials.refresh_token
    authorizations << authorization
  end

    has_attached_file :avatar,
      :styles => { :thumb => 'x100', :croppable => '600x600>', :big => '1000x1000>' },
      :path => ':rails_root/public/system/:class/:attachment/:id/:hash.:extension',
      :url => "/system/:class/:attachment/:id/:hash.:extension",
      :hash_secret => Settings.paperclip_hash_secret,
      :default_url => "/assets/avatars/normal/missing.png"

  has_many :authorizations, :dependent => :destroy
  store :settings, :accessors => [:first_name, :last_name, :location, :tagline]

    before_post_process :transliterate_file_name
    private
    def transliterate_file_name
      return unless avatar_file_name == 'stringio.txt'
      extension = avatar_content_type.split('/').last
      filename = avatar_file_name.split('.').first
      self.avatar.instance_write(:file_name, "#{filename}.#{extension}")
    end
end
