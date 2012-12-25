<%= broadcast "/pages/#{@page.id}" do @page.to_json end %>

<%# @page.layouts.each do |layout| %>
<%#= broadcast "/pages/#{layout.id}" do layout.to_json end %>
<%# end %>

$("textarea").removeClass('dirty')
