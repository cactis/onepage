# -*- encoding : utf-8 -*-

module ApplicationHelper

  def title arguments, options = {}
    case arguments
    when String
      @title = arguments
      options[:class] = [options[:class], 'error'].compact.join(' ') if options[:error]
      return content_tag(:h1, [options[:header], @title, options[:trailer]].compact.join(' ').html_safe, options.except(:error, :header, :trailer)).html_safe
    when Hash
      sitename = arguments[:site_name]
      if @title
        return "#{strip_tags(@title)} - #{sitename}"
      else
        return "#{sitename}"
      end
    end
  end

  def broadcast(channel, token = nil, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    debug message, 'message'
    uri = URI.parse("http://#{$SNIPPET_HOST}:9293/pusher")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def link_to_polymorphic(obj, options={})
    return unless obj
    if title = sanitize(options[:title])
    else
      title = truncate(obj.title, :length => options[:length] || 20)
    end
    # title = title.present? ? title : '(未命名)'
    link_to title, polymorphic_path(obj), :title => obj.title, :target => options[:target]
  end

  def link_to_oauth_login(provider)
    return
    # "<a href='#{user_oauth_authorize_url(:facebook)}' class='oauth_login Facebook'>以facebook登入</a>".html_safe
    case provider
    when :facebook
      link_to("Sign in with Facebook", user_omniauth_authorize_path(provider), :class => "oauth_login facebook")
    when :yahoo
      # link_to "Sign in with Yahoo", user_omniauth_authorize_path(:open_id, :openid_url => "http://yahoo.com"), :class => 'yahoo'
      link_to "sign in with yahoo", user_omniauth_authorize_path(:yahoo)#, :openid_url => "http://yahoo.com")
    when :google_apps
      link_to "Sign in with Google", user_omniauth_authorize_path(:google_apps), :class => 'oauth_login google'
    when :twitter
      link_to "Sign in with Twitter", user_omniauth_authorize_path(:twitter), :class => 'twitter'
    end
  end

  def author_tools(obj)
    return unless can_edit?(obj)
    [link_to_edit(obj), link_to_snippet_lib(obj), link_to_delete(obj), link_to_rescue(obj)].compact.map{|tool| "[#{tool}]"}.join.html_safe
  end

  def link_to_delete(obj, options = {})
    return unless can_edit?(obj)
    title = options[:title] || "刪除"
    title = "<i class='icon'>Â</i> #{title}".html_safe
    link_to title, polymorphic_path(obj), :method => :delete, :confirm => "delete it?", :class => 'btn'
  end

  def link_to_edit(obj, options = {})
    return unless can_edit?(obj)
    href = options[:href] || polymorphic_path([:edit, obj])
    link_to "<i class='icon'>></i> 編輯".html_safe, href, :class => 'btn'
  end


  #  def content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
  #    require 'cgi'
  #    CGI.unescapeHTML(CGI.unescapeHTML(super))
  #  end
end
