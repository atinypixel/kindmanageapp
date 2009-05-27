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
  
  def inbox_entry(object, title, body=nil, options={})
    haml_tag :div, :id => "entry_#{object.entry.id}", :class => "inbox entry #{object.entry.content_type_name}" do
      # content_type
      haml_concat %{<ul class="type"><li class="label"><span>#{object.entry.content_type_name}</span></li></ul>}
      
      # content
      haml_tag :div, :class => "content" do
        haml_tag :div, :class => "body" do
          haml_tag :h3 do
            title_truncate_number = title.length < 50 ? 50 : 100 
            haml_concat truncate(title.gsub(/((?:@\w+\s*)+)$/, ""), title_truncate_number)
            if body
              haml_concat %{<span class="body">#{body.scan(/^.{#{title.length < 50 ? 50 : 75}}/)} ...</span>}
            end
          end
        end
      end
      
      # options
      haml_tag :div, :class => "options" do
        haml_tag :div, :class => "group user" do
          if created_by_current_user?(object.entry)
            # haml_concat link_to_remote image_tag("trash_icon.gif"), :url => project_entry_path(object.entry.project, object.entry, :context => options[:context]), :method => :delete, :confirm => "Are you sure?"
            # haml_concat "|"
            # haml_concat link_to_remote "Edit", :url => edit_project_entry_path(object.entry.project, object.entry, :content_type => object.entry.content_type_name, :context => options[:context]), :method => :get
            # haml_concat "|"
          end
          haml_concat "From #{created_by_current_user?(object.entry) ? 'You' : object.entry.user.name}"
          haml_concat "|"
          haml_concat link_to "View", project_entry_path(object.entry.project, object.entry)
          haml_concat "|"
          haml_concat link_to "Expand", "#"
          
        end
        
      end
    end
  end
  
  def delete_project_link(project)
    link_to_remote image_tag("admin_trash_icon.gif"), :url => project_path(project), :method => :delete, :html => {:class => "destroy"}, :confirm => "Deleting this project will also remove all of it's entries. Are you sure?"
  end
  
  def content_with_tags(content, entry, apply_formatting=true, options={}) 
    # remove tags from content and establish some objects
    content_without_tags = content.gsub(/((?:@\w+\s*)+)$/, "")
    
    if apply_formatting
      puts markdown(content_without_tags)
    else
      haml_tag :span, content_without_tags
    end
    
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