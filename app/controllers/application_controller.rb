# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  #  after_filter :set_access_control_headers
  #  def set_access_control_headers
  #    headers['Access-Control-Allow-Origin'] = '*'
  #    headers['Access-Control-Request-Method'] = '*'
  #  end


  before_filter :authenticate_user!

  def resources_name; rname = request.env["PATH_INFO"].split('/')[1]; rname ? rname : 'welcome'; end
  def resource_name; resources_name.singularize; end
  helper_method :resources_name, :resource_name

  def supervisor; User.find_by_email('chitsung.lin@gmail.com'); end
  def supervisor?; current_user == supervisor; end
  helper_method :supervisor, :supervisor?

  def can_edit?(obj); return supervisor? || (current_user && current_user == obj.user); end
  helper_method :can_edit?

  def display_snippet_host_url(snippet = nil)
    "http://#{$SNIPPET_DISPLAY_HOST}#{snippet ? polymorphic_path(snippet) : nil}"
  end
  helper_method :display_snippet_host_url

  def lib_snippet_host_url(snippet = nil)
    "http://#{$SNIPPET_LIB_HOST}#{snippet ? "/#{snippet.class.to_s.downcase.pluralize}/#{snippet.title}" : nil}"
  end
  helper_method :lib_snippet_host_url

  def snippet_host_url(snippet = nil)
    "http://#{$snippet_HOST}#{snippet ? polymorphic_path(snippet) : nil}"
  end
  helper_method :snippet_host_url

  def development?; Rails.env = 'development'; end
  helper_method :development?

  def debug(*args)
    # return unless development?
    title ||= ""
    title += Time.now.to_s
    logger.ap "--- #{controller_name}/#{action_name} " + title + "-" * 30
    logger.ap args
  end
  helper_method :debug

  def display_site?
    request.env['SERVER_NAME'] == $SNIPPET_DISPLAY_HOST
  end

  def site_mode
    # display, lib
    request.env['SERVER_NAME'].split('.')[0]
  end

  before_filter :render_layout
  def render_layout
    debug params, 'params'
    if display_site? && controller_name != 'snippetes' && action_name != 'show'
      redirect_to snippet_host_url
    end
  end
end
