# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def create_or_update(object, options={})
    unless options[:choose_method]
      object.new_record? ? "create" : "update"
    else
      "put" unless object.new_record?
    end
  end
  
  def new_or_edit(object)
    object.new_record? ? "new" : "edit"
  end
  
  def choose_admin_link(name, options={})
    unless options[:close]
      link_to_function name do |page|
        page.replace_html "admin", :partial => options[:partial]
        page.visual_effect :blind_down, "admin", :duration => 0.1
        page << "$('nav_choose_#{options[:type]}').addClassName('on')"
        page << "$('nav_choose_#{%r{[^\w+)]}}')"
        page.form.reset "project_form" if options[:type] == "project"
      end
    else
      link_to_function image_tag("close_admin.gif") do |page|
        page.remove "#{options[:type]}_list"
        page.hide "admin"
        page << "$('nav_choose_#{options[:type]}').removeClassName('on');"
        page.form.reset "project_form" if options[:type] == "project"
      end
    end
  end
  
  def delete_project_link(project)
    link_to_remote image_tag("admin_trash_icon.gif"), :url => project_path(project), :method => :delete, :html => {:class => "destroy"}, :confirm => "Deleting this project will also remove all of it's entries. Are you sure?"
  end
  
  def highlight_at_tags(content)
    content.gsub(/@(\w*)/, '<a href="/workspaces/\1" class="at_tag"><span class="at_symbol">@</span><span>\1</span></a>')
  end
  
  def page_label(label, name)
    
  end
end
