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
  
  def close_admin_link
    link_to_function image_tag("close_admin.gif"), :class => "close_admin" do |page|
      page << "$('#masthead div.panel').hide();"
      page << "$(this).parent().removeClass('on');"
    end
  end
  
  def delete_project_link(project)
    link_to_remote image_tag("admin_trash_icon.gif"), :url => project_path(project), :method => :delete, :html => {:class => "destroy"}, :confirm => "Deleting this project will also remove all of it's entries. Are you sure?"
  end
  
  def highlight_at_tags(content, project=nil)
    # new_content = content.gsub(/@(\w+)/, '<a href="/workspaces/\1" class="at_tag"><span class="at_symbol">@</span><span>\1</span></a>')
    content.gsub(/@(\w+)/m) do |w|
      ws = Workspace.find_by_name("#{$1}")
      %{<a href=\"#{ws.project ? project_path(ws.project) : ''}/workspaces/#{$1}" class="at_tag"><span class="at_symbol">@</span><span>#{$1}</span></a>}
    end
    # project ? new_content.gsub(/\="\/workspaces\//, "=\"project/#{project.id}") : new_content
  end
  
  def page_label(label, name)
    
  end
end
