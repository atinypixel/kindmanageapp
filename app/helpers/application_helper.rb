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
  
  def highlight_at_tags(content)
    content.gsub(/@(\w+)/m) do |w|
      ws = Workspace.find_by_name("#{$1}")
      if ws
        %{<a href="#{ws.project ? project_path(ws.project) : ''}/workspaces/#{$1}" class="at_tag"><span class="at_symbol">@</span><span>#{$1}</span></a>}
      else
        %{<a href="#" title="This workspace has been removed or modified" class="at_tag invalid_at_tag"><span class="at_symbol">@</span><span>#{$1}</span></a>}
      end
    end
  end
  
  def workspace_list_for(object)
    workspaces ||= object.workspaces.scoped_by_project
    haml_tag :ul, :id => "workspaces" do
      workspaces.each do |workspace|
        workspace_path = workspace.project ? project_workspace_path(workspace.project, workspace.name) : workspace_path(workspace.name)
        haml_tag :li, :id => "workspace_#{workspace.id}", :class => "workspace" do
          haml_tag :a, :href => workspace_path do
            if workspace.project
              haml_tag :span, :class => "has_project" do
                puts "*"
              end # span.has_project
            end
            haml_tag :span, :class => "name" do
              puts workspace.name
            end # span.name
          end # anchor
        end # li.workspace#workspace_00
      end
    end # ul#workspaces
  end
  
  def page_label(label, name)
    
  end
end
