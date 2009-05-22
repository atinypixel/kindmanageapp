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
  
  def switch_admin_context_link(object)
    
  end
  
  def workspace_list_for(object, context=nil)
    context = context.to_s
    workspaces = context == "project" ? object.workspaces.scoped_by_project : object.workspaces
    haml_tag :ul, :class => "workspaces" do
      workspaces.each do |workspace|
        workspace_path = workspace.project ? project_workspace_path(workspace.project, workspace.name) : workspace_path(workspace.name)
        haml_tag :li, :id => "workspace_#{workspace.id}#{"_" + context if context}", :class => "workspace" do
          haml_tag :a, :href => workspace_path do
            if workspace.project
              haml_tag :span, :class => "has_project" do
                haml_concat "*"
              end # span.has_project
            end
            haml_tag :span, :class => "name" do
              haml_concat workspace.name
            end # span.name
          end # anchor
        end # list_item
      end # workspaces.each do |workspace|
    end # ul.workspaces
  end
  
  def project_list_for(object, project_in_view, context=nil)
    context = context.to_s
    projects ||= object.projects
    haml_tag :ul, :class => "projects" do
      projects.each do |project|
        haml_tag :li, :id => "project_#{project.id}#{"_" + context if context}", :class => "project #{'hide' if project_in_view == project.id.to_s}" do
          haml_tag :span, :class => "name" do
            haml_concat delete_project_link(project)
            haml_concat link_to(project.name, project_path(project))
          end # span.name
          
          # haml_tag :span, :class => "meta" do
          #   puts "#{pluralize(project.number_of_entries_for("notes"), "note")} and #{pluralize(project.number_of_entries_for("tasks"), "task")}"
          # end
        end
      end
    end
  end
  
  def close_admin_link
    link_to_function image_tag("close_admin.gif"), :class => "close_admin" do |page|
      page << "$('#admin div.panel').hide();"
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
        %{<a href="#" title="THIS WORKSPACE HAS BEEN REMOVED, MODIFIED OR DOESN'T EXIST" class="at_tag invalid_at_tag"><span class="at_symbol">@</span><span>#{$1}</span></a>}
      end
    end
  end
  
  def page_label(label, name)
    
  end
end