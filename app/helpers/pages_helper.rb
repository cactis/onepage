# -*- encoding : utf-8 -*-
module PagesHelper

  def less_import(page)
    %Q(<select class='chzn-select' data-placeholder="Choose a Country" style="width:350px;" multiple="" tabindex="3">
                <option value="United States">United States</option>
                <option value="United Kingdom">United Kingdom</option>
                <option value="Afghanistan">Afghanistan</option>
                <option value="Albania">Albania</option>

                <option value="Singapore">Singapore</option>

                <option value="Zambia">Zambia</option>
                <option value="Zimbabwe">Zimbabwe</option>
              </select>)
  end

#  def dropdown_menu(page)
#  raw = <<-haml
#= Page.count
#  haml
#  raw = <<-haml
#%div.btn-group.dropdown
#  %a.btn.btn-info{:href => page_path(page)}
#    = "Return to <strong>#{page.book.title}</strong>".html_safe
#  %a.btn.btn-info.dropdown-toggle{'data-toggle' => 'dropdown', :href =>'#'}
#    %span.caret
#  %ul.dropdown-menu{'aria-labelledby' => 'dLabel', 'role' => 'menu', :id => 'movepage_btn'}
#    - (page.book.pages - [page]).each do |pg|
#      %li
#        %a{'data-page-id' => pg.id, :href => '#'}= "Use Layout <strong>#{pg.title}</strong>".html_safe
#    haml
#    debug raw, 'raw'
#    Haml::Engine.new(raw).render
#  end
end
