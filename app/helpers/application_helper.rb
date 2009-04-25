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
  
  def choose_project_link(options={})
    unless options[:close]
      link_to_remote("Choose a project",
        :url => account_projects_path,
        :success => "$('nav_choose_project').addClassName('on')",
        :method => :get)
    else
      link_to_function "x" do |page|
        page.visual_effect :blind_up, "admin", :duration => 0.2
        page.delay(0.2) {
          page << "$('nav_choose_project').removeClassName('on');"
        }
      end
    end
  end
  
  def delete_project_link(project)
    link_to_remote image_tag("admin_trash_icon.gif"), :url => project_path(project), :method => :delete, :html => {:class => "destroy"}, :confirm => "Deleting this project will also remove all of it's entries. Are you sure?"
  end
  
  def highlight_hashtags(content)
    content.gsub(/(#\w+)/, '<a href="#" class="hashtag">\0</a>')
  end
end
