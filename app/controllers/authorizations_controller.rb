# -*- encoding : utf-8 -*-
class AuthorizationsController < ApplicationController
  def index
    @authorizations = Authorization.page params[:page]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @authorizations }
    end
  end

  def show
    @authorization = Authorization.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @authorization }
    end
  end

  def new
    if params[:provider]
      url = "http://accounts.google.com/o/oauth2/auth"
      redirect_uri = "http://localhost/auth/googel/callback"
      client_id = Settings.google_client_id
      scope = Settings.google_scope
      access_type = 'offline'
      url = "#{url}?redirect_uri=#{redirect_uri}&response_type=code&client_id=#{client_id}&scope=#{scope}&access_type=#{access_type}"
      redirect_to url
    else
      @authorization = Authorization.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @authorization }
      end
    end
  end

  def edit
    @authorization = Authorization.find(params[:id])
  end

  def create
    auth = request.env["omniauth.auth"]
    debug auth, 'auth'
    provider = auth["provider"]
    uid = auth["uid"]

    case provider
    when 'google'
      # access_token = env["omniauth.auth"]['extra']['access_token']
      access_token = auth['extra']['access_token']
      debug access_token, 'access_token'

      token = access_token.token
      secret = access_token.secret
      debug token, 'token'
      debug secret, 'secret'

      authorization = user_authorization(provider, uid, token, secret, auth)

      # 暫時關閉
      path = "https://www.google.com/m8/feeds/contacts/default/full?max-results=10&v=3.0" #alt=rss
      results = google_request access_token, path
      # debug results, 'results'
      contacts = google_contacts results
      # debug contacts, 'contacts'
      authorization.contacts!(contacts)
      notice = "#{provider} 通訊錄已導入!"

      #      # path = "https://www.google.com/calendar/feeds/default/owncalendars/full"
      #      path = "https://www.google.com/calendar/feeds/#{authorization.uid}/private/full?updated-min=#{1.month.ago.iso8601}&v=2.0"
      #      path = "https://www.googleapis.com/calendar/v3/calendars/7fv3bbhq9d3nn1u65v5kp1lrag%40group.calendar.google.com/events?pp=1"
      #      calendar_id = "7fv3bbhq9d3nn1u65v5kp1lrag%40group.calendar.google.com"
      #      path = "https://www.googleapis.com/calendar/v3" + "/calendars/" + calendar_id

      #      path = "https://www.googleapis.com/calendar/v3/users/me/calendarList/?pp=1&key=#{GOOGLE_CONSUMER_KEY}"

      #      # &fields=link,entry(@gd:etag,id,updated,content,title,gd:where,link[@rel='edit'])"
      #      path = "https://www.googleapis.com/calendar/v3/calendars/7fv3bbhq9d3nn1u65v5kp1lrag%40group.calendar.google.com/events/?pp=1&key="
      #      debug path, 'path'
      #      results = google_request access_token, path
      #      debug results, 'results'
      #      #      calendars = []
      #      #      index = 0
      #      #      results.elements.each('//entry') do |entry|
      #      #        debug entry, 'entry' if index == 0
      #      #        index += 1
      #      #        event = {}
      #      #        event['title'] = entry.elements['title'].text
      #      #        event['content'] = entry.elements['content'].text
      #      #        event['updated'] = entry.elements['updated'].text
      #      #        if where = entry.elements['gd:where']
      #      #          event['where'] = where.attributes['valueString']
      #      #        end
      #      #        calendars << event
      #      #      end
      #      # debug calendars, 'calendars'
      #      # debug index, 'index'
      #      debug path, 'path'
      #      # debug results.elements.each('//item').first, "results.elements.each('//item').first"

    when 'facebook'
      token = auth["credentials"]["token"]
      debug auth["credentials"], 'auth["credentials"]'

      authorization = user_authorization(provider, uid, token, secret, auth)

      # debug token, 'token'
      # # https://developers.facebook.com/docs/reference/api/user/
      # path = "https://graph.facebook.com/me/friends?access_token=#{token}&fields=name,picture,birthday"
      # debug path, 'path'
      # require 'open-uri'
      # contacts = JSON.parse(open(path).read)["data"]

      contacts = authorization.facebook_contacts_request
      debug results, 'results'
      contacts.each {|r|
        r['token'] = r['id']
        r.delete('id')
        r['birthday'] = Date.strptime(r['birthday'], '%m/%d/%Y') if r['brithday']
      }
      debug contacts, 'contacts'

      notice = authorization.contacts!(contacts)
      # authorization.facebook_contacts(token, results)

      # notice = authorization.facebook_put_wall_post(token)
    when 'twitter'

    end

    # 導入行事曆
    # http://code.google.com/intl/zh-TW/apis/calendar/data/2.0/reference.html
    # xml = google_request access_token, "https://www.google.com/calendar/feeds/default/owncalendars/full"
    # google_calendars xml

    debug [User.count, Authorization.unscoped.count, Contact.unscoped.count], '[User.count, Authorization.unscoped.count, Contact.unscoped.count]'
    redirect_to root_url, :notice => notice
  end

  def failure
    redirect_to root_path, :alert => "認證失敗。"
  end

  def update
    @authorization = Authorization.find(params[:id])
    respond_to do |format|
      if @authorization.update_attributes(params[:authorization])
        format.html { redirect_to @authorization, notice: 'Authorization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @authorization.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @authorization = Authorization.find(params[:id])
    @authorization.destroy

    respond_to do |format|
      format.html { redirect_to authorizations_url }
      format.json { head :no_content }
    end
  end

  private

  def google_calendars(xml)
    calendars = []
    xml.elements.each('//entry') do |entry|
      # debug entry, 'entry'
    end
  end

  def google_contacts(xml)
    contacts = []
    xml.elements.each('//entry') do |entry|
      # debug entry, 'entry'
      person = {}
      person['name'] = entry.elements['title'].text
      if gd_email = entry.elements['gd:email']
        # debug entry.elements['gd:email'], "entry.elements['gd:email']"
        person['email'] = gd_email.attributes['address']
        person['token'] = gd_email.attributes['address']
      end

      # debug entry.elements['gd:phoneNumber'], "entry.elements['gd:phoneNumber']"
      if phoneNumber = entry.elements['gd:phoneNumber']
        person['phone_number'] = phoneNumber.text
      end

      # debug entry.elements['gd:structuredPostalAddress'], "entry.elements['gd:structuredPostalAddress']"
      if entry.elements['gd:structuredPostalAddress']
        # debug entry.elements['gd:structuredPostalAddress'].elements['gd:formattedAddress'], "entry.elements['gd:structuredPostalAddress'].elements['gd:formattedAddress']"
        if formattedAddress = entry.elements['gd:structuredPostalAddress'].elements['gd:formattedAddress']
          person['address'] = formattedAddress.text
        end
      end

      # debug entry.elements['gContact:birthday'], "entry.elements['gContact:birthday']"
      if birthday = entry.elements['gContact:birthday']
        person['birthday'] = birthday.attributes["when"]
      end
      # debug person, 'person'
      contacts << person
    end
    return contacts
  end

  def google_request(access_token, path)
    response = access_token.request(:get, path)
    require 'rexml/document'
    xml = REXML::Document.new(response.body)
    return xml
  end

  def user_authorization(provider, uid, token, secret, auth)
    if !current_user
      user = User.find_by_email(uid) || User.create(:email => uid, :password => Devise.friendly_token)
      sign_in user
      User.current = user
    end
    authorization = current_user.authorization!(provider, uid, token, secret, auth)
  end
end
