# -*- encoding : utf-8 -*-
class Authorization < ActiveRecord::Base
  # store_configurable
  store :_config, :accessors => [:raw]

  belongs_to :user
  has_many :contacts, :dependent => :destroy #:nullify
  has_many :calendars, :dependent => :destroy #:nullify

  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => [:provider, :user_id]

  def name; provider; end

  default_scope lambda {
    select("#{self.table_name}.*")
    .group("#{self.table_name}.id")
    .where( User.current ? ["#{self.table_name}.user_id = ? ", User.current.id] : "1 < 1")
  }

  #  def access_token
  #    token_url = Settings.facebook_token_url
  #    opts = {
  #        "refresh_token"=> self.refresh_token,
  #        "client_id" => Settings.facebook_client_id,
  #        "client_secret" => Settings.facebook_secret,
  #        "grant_type" => "refresh_token"
  #      }
  #    debug opts, 'opts'
  #    tokens = exchange_authorization_code_for_token(token_url, opts)
  #    debug tokens, 'tokens'
  #    return tokens["access_token"]
  #  end


  def token_request
    debug self, 'authorization'
    token_url = eval("Settings.#{provider}_token_url")
    debug token_url, 'token_url'
    opts = {
        "refresh_token"=> self.refresh_token,
        "client_id" => eval("Settings.#{provider}_client_id"),
        "client_secret" => eval("Settings.#{provider}_secret"),
        "grant_type" => eval("Settings.#{provider}_grant_type")
      }
    debug opts, 'opts'
    case provider
    when 'google'
      tokens = exchange_authorization_code_for_token(token_url, opts)
      debug tokens, 'tokens'
      return tokens["access_token"]
    when 'facebook'
      token
    end
  end

  def exchange_authorization_code_for_token(token_url, opts)
    # 利用 code 交換 refresh-token
    self.update_attributes(:token => opts["code"]) if opts["code"]

    uri = URI.parse(token_url)
    # debug uri, 'uri'
    # debug opts, 'opts'

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(opts)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if token_url =~ /^https/
    response = http.request(req)

    File.write("tmp/#{this_method}.html", response.body.force_encoding('utf-8'))
    debug response.body, 'response.body'
    debug response.body.class, 'response.body.class'

    case provider
    when 'google'
      tokens = JSON.parse(response.body)
      self.update_attributes(:token => tokens["access_token"], :refresh_token => tokens["refresh_token"]) if tokens["refresh_token"]
    when 'facebook'
      tokens = {'access_token' => response.body.split('=').last}
    end
    debug tokens, 'tokens'

    debug self, 'authorization'
    return tokens
  end

  def send_the_request(uri, opts)
    debug uri, 'uri'
    debug opts, 'opts'
    uri.query = opts.to_param
    debug uri.query
    debug uri, 'uri'
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    debug response.body, 'response.body'
    return response
  end

  def facebook_contacts(access_token, results)
    access_token ||= 'AAAAAKr3xukABAP1Bf5deG3WkarirYzHQHX4YB5JReMWkJsG4f3BOrhyMSVRtZAAU61p43aMbocZCrcbZAVMIZAGWbF1OrTN1Pgmgnu4FlgZDZD'
    @graph = Koala::Facebook::API.new(access_token)
    results.each do |friend|
      # logger.ap friend
      logger.ap "friends/#{friend['id']}"
      contact = @graph.get_connections("me", "mutualfriends/#{friend['id']}")
      logger.ap contact
    end
  end

  def facebook_contacts_url
    # Facebook 的好友名單呼叫網址
    "https://graph.facebook.com/me/friends?access_token=#{token}&fields=name,picture,birthday,username,events,first_name,last_name"
  end

  def facebook_contacts_request
    # 傳回 Facebook 的好友名單
    require 'open-uri'
    JSON.parse(open(facebook_contacts_url).read)["data"]
  end

  def facebook_put_wall_post(message)
    # 測試 po 文
    message["caption"] = "由{*actor*}發佈"
    #access_token = token # ||= 'AAAAAKr3xukABAP1Bf5deG3WkarirYzHQHX4YB5JReMWkJsG4f3BOrhyMSVRtZAAU61p43aMbocZCrcbZAVMIZAGWbF1OrTN1Pgmgnu4FlgZDZD'
    api = Koala::Facebook::API.new(token)
    #    api.put_wall_post("Hello there!", {
    #         "name" => "Link name",
    #         "link" => "http://slidking.airfont.com/",
    #         "caption" => "{*actor*} posted a new review",
    #         "description" => "This is a longer description of the attachment",
    #         "picture" => "http://slidking.airfont.com/shots/1iE1KxWsgS6ZTirhSjkz_360_s.jpeg"
    #       })
    api.put_wall_post(message["subejct"], message)

    return "已發佈到您的FB!"
    rescue Exception => exception
      logger.ap exception
      return exception.message
  end

  def contacts!(contacts)
    return unless contacts.present?
    #  logger.ap contacts
    self.contacts.destroy_all
    contacts.each do |contact|
      self.contacts.create(contact)
    end
    return "#{self.provider}通訊錄已導入。"
  end
end
