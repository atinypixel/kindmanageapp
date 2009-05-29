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
    # workspaces = context == "project" ? object.workspaces.scoped_by_project : object.workspaces
    case context
    when "project"
      workspaces = object.workspaces.scoped_by_project
    when "all"
      workspaces = object.workspaces.not_scoped
    end
    haml_tag :ul, :class => "workspaces" do
      workspaces.each do |workspace|
        workspace_path = workspace.project ? project_workspace_path(workspace.project, workspace.name) : workspace_path(workspace.name)
        unless @workspace && @workspace.id == workspace.id
          haml_tag :li, :id => "workspace_#{workspace.id}#{"_" + context if context}", :class => "workspace" do
            haml_concat destroy_workspace_link(workspace, context)
            haml_tag :a, :href => workspace.project ? project_workspace_path(workspace.project, workspace.id) : workspace_path(workspace.id) do
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
        end # unless
      end # workspaces.each do |workspace|
    end # ul.workspaces
  end
  
  def project_list_for(object, project_in_view, context=nil)
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
      link_to_remote image_tag("wsa_trash_icon.png"), 
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
  
  
  def content_with_tags(content, entry, apply_formatting=true, options={}) 
    # remove tags from content and establish some objects
    content_without_tags = content.gsub(/((?:@\w+\s*)+)$/, "")
    
    # display content
    if apply_formatting
      puts markdown(content_without_tags)
    else
      haml_tag :span, content_without_tags
    end
    
    # display workspaces (e.g collections)
    unless entry.collections.empty?
      haml_tag :ul, :class => "workspaces", :id => "workspaces_for_entry_#{entry.id}" do
        entry.collections.each do |c|
          haml_tag :li, :id => "collection_#{c.id}_for_entry_#{c.entry_id}" do
            case options[:context]
            when /^workspace|project/
              haml_concat image_tag("46.png")
            when "entry"
              if created_by_current_user?(entry)
                haml_concat link_to_remote image_tag("trash_icon.gif"), 
                              :url => collection_path(c, 
                              :context => options[:context]), 
                              :method => :delete, 
                              :confirm => "Are you sure?", 
                              :html => {:class => "remove_collection"}
              else
                haml_concat image_tag("46.png")
              end
            end
            haml_concat link_to c.workspace.name, "#{c.workspace.project_id ? project_workspace_path(c.workspace.project, c.workspace) : workspace_path(c.workspace)}", :class => "at_tag"
          end
        end
      end
      haml_tag :div, :class => "clear"
    end
  end
  
  def content_without_tags(content)
    
  end
  
  def collections_for(object, options={})
    unless object.collections.empty?
      haml_tag :ul, :class => "workspaces", :id => "workspaces_for_entry_#{object.id}" do
        object.collections.each do |c|
          haml_tag :li, :id => "collection_#{c.id}_for_entry_#{c.entry_id}" do
            case options[:context]
            when /^workspace|project/
              haml_concat image_tag("46.png")
            when "entry"
              if created_by_current_user?(object)
                haml_concat link_to_remote image_tag("trash_icon.gif"), 
                              :url => collection_path(c, :context => options[:context]), 
                              :method => :delete, 
                              :confirm => "Are you sure?", 
                              :html => {:class => "remove_collection"}
              else
                haml_concat image_tag("46.png")
              end
            end
            haml_concat link_to c.workspace.name, "#{c.workspace.project_id ? project_workspace_path(c.workspace.project, c.workspace) : workspace_path(c.workspace)}", :class => "at_tag"
          end
        end
      end
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