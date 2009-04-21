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
      link_to_remote("Choose a project <span class=\"indicator\">&nbsp;</span>", 
        :url => account_projects_path,
        :success => "$('nav_choose_project').addClassName('on')",
        :method => :get)
    else
      link_to_function "x" do |page|
        page << "$('nav_choose_project').removeClassName('on');"
        page.hide "admin"
      end
    end
  end
end
