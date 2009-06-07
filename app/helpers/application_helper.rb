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
  
  def display_time_or_day(created_at)
    if created_at.to_date.eql?(Time.zone.now.to_date)
      display = created_at.strftime("%l:%M%p").downcase
    elsif created_at.to_date.eql?(Time.zone.now.to_date - 1)
      display = "yesterday"
    else
      display = created_at.strftime("%B %d")
    end
  end
  
  def display_time(created_at)
    created_at.strftime("%l:%M%p").downcase
  end
  
  def display_day(created_at)
    if created_at.to_date.eql?(Time.zone.now.to_date)
      display = "Today"
    elsif created_at.to_date.eql?(Time.zone.now.to_date - 1)
      display = "Yesterday"
    else
      display = created_at.strftime("%B %d")
    end
  end
  
  def group_by_day(entries)
    entries.group_by{|e| e.created_at.to_date}.sort{|a,b| b[0] <=> a[0]}
  end
  
  def workspace_list_for(object, context=nil)
    context = context.to_s
    case context
    when "project"
      workspaces = object.workspaces.scoped_by_project
    when "all"
      workspaces = object.workspaces.not_scoped
    end
    
    capture_haml do
      haml_tag :ul, :class => "workspaces" do
        workspaces.each do |workspace|
          workspace_path = workspace.project ? project_workspace_path(workspace.project, workspace.name) : workspace_path(workspace.name)
          haml_tag :li, :id => "workspace_#{workspace.id}#{"_" + context if context}", :class => "workspace" do
            haml_concat destroy_workspace_link(workspace, context)
            haml_tag :a, :href => workspace.project ? project_workspace_path(workspace.project, workspace.id) : workspace_path(workspace.id) do
              haml_tag :span, :class => "name" do
                haml_concat workspace.name
              end # span.name
            end # anchor
          end # list_item
        end # workspaces.each do |workspace|
      end # ul.workspaces
    end # capture_haml
  end
  
  def project_list_for(object, project_in_view=nil, context=nil)
    context = context.to_s
    projects ||= object.projects
    haml_tag :ul, :class => "projects" do
      projects.each do |project|
        haml_tag :li, :id => "project_#{project.id}#{"_" + context}", :class => "project #{'hide' if project_in_view == project.id.to_s}" do
          haml_tag :span, :class => "name" do
            haml_concat destroy_project_link(project, context)
            haml_concat link_to(project.name, project_path(project))
          end # span.name
        end
      end
    end
  end
  
  def destroy_workspace_link(workspace, context)
    unless @workspace && @workspace.id == workspace.id
      link_to_remote image_tag("trash_icon.png"), 
        :url => workspace_path(workspace, :context => context), 
        :method => :delete,
        :complete => visual_effect(:fade, "#workspace_#{workspace.id}_#{context}"),
        :html => {:class => "destroy"}, 
        :confirm => "Are you sure?"
    end
  end
  
  def destroy_project_link(project, context)
    link_to_remote image_tag("admin_trash_icon.gif"), 
      :url => project_path(project), 
      :method => :delete,
      :complete => visual_effect(:fade, "project_#{project.id}_#{context}"),
      :html => {:class => "destroy"},
      :confirm => "Deleting this project will also remove all of it's entries. Are you sure?"
  end
  
  def close_admin_link
    link_to_function image_tag("close_admin.gif"), :class => "close_admin" do |page|
      page << "$('#admin div.panel').hide();"
      page << "$(this).parent().removeClass('on');"
    end
  end
        
  def page_label(label, name)
    
  end
  
  def markdown(text)
    Markdown.new(text).to_html
  end
  
  def collection_extists_for?(entry, workspace)
    Collection.find_by_workspace_id_and_entry_id(entry.id, workspace.id).nil?
  end
  
  def view_context(current_object)
    current_object.class.name.downcase
  end
end