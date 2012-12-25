# -*- encoding : utf-8 -*-
module SnippetsHelper
  def link_to_versions(snippet)
    link_to "版本清單", polymorphic_path(snippet, :versions_list => true)
  end

  def link_to_snippet_display(snippet)
    link_to snippet.title, display_snippet_host_url(snippet), :class => 'display'
  end

  def link_to_snippet_lib(snippet)
    link_to 'lib', lib_snippet_host_url(snippet), :class => 'lib', :target => '_blank'
  end

  def link_to_rescue(obj)
    link_to "除錯", edit_snippet_path(obj, :mode => 'rescue')
  end

end

