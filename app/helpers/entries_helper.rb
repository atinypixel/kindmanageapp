module EntriesHelper
  def entry_list_item(entry, opt={})
    capture_haml do
      haml_tag :div, :class => "entry #{entry.content_type}", :id => "entry_#{entry.id}" do
        haml_concat %{<div class="content_type"><span>#{entry.content_type}</span></div>}
        haml_tag :div, :class => "content slim" do
          # title
          haml_tag :h3, :class => "title" do
            unless @project
              haml_concat link_to(entry.project.name, project_path(entry.project), :class => "owning_project")
            end
            haml_concat link_to(entry.title.gsub(/((?:@\w+\s*)+)$/, ""), project_entry_path(entry.project, entry))
          end
          # meta
          haml_tag :div, :class => "meta" do
            if created_by_current_user?(entry)
              # comment count
              haml_concat %{<span class="comments#{entry.collections.exists? ? ' separate' : ''}">0 comments</span>}
              # collections
              if entry.collections.exists?
                haml_tag :ul, :class => "workspaces" do
                  entry.collections.each do |c|
                    haml_tag :li, :class => "workspace" do
                      haml_concat link_to(c.workspace.name, "#{c.workspace.project ? project_workspace_path(c.workspace.project, c.workspace) : workspace_path(c.workspace)}")
                    end # li.workspace
                  end # entry.collections
                end # ul.workspaces
              end # if entry.collections.exists?
            end
          end
        end
        # options
        haml_tag :div, :class => "meta" do
          haml_concat %{<div class="group user">From <strong>#{entry.by_line(current_user)}</strong></div>}
          haml_concat %{<div class="group">#{time_ago_in_words(entry.created_at)} ago</div>}
        end
      end
    end
  end
  
  def entry_item(entry, opt={})
    capture_haml do
      content = entry.content.body.gsub(/((?:@\w+\s*)+)$/, "")
      
      haml_tag :div, :class => "form_area", :style => "display:none;"
      haml_tag :div, :class => "entry #{entry.content_type}", :id => "entry_#{entry.id}" do
        haml_tag :div, :class => "content", :id => "content_for_entry_#{entry.id}" do
          case entry.content_type
            when "note"
              haml_tag :h3, :class => "title" do
                haml_concat entry.content.title
              end
              haml_tag :div, :class => "body" do
                haml_concat markdown(content)
              end
            when "task"
              haml_tag :h3, :class => "title" do
                haml_concat content
              end
            when "upload"
            when "issue"
          end # case entry.content_type
          haml_tag :br
          # meta
          haml_tag :div, :class => "meta" do
            if entry.collections.exists?
              haml_tag :ul, :class => "workspaces" do
                entry.collections.each do |c|
                  haml_tag :li, :class => "workspace" do
                    haml_concat link_to_remote(image_tag("trash_icon.png"), 
                                  :url => collection_path(c, 
                                  :context => @context),
                                  :method => :delete, 
                                  :confirm => "Are you sure?",
                                  :html => {:class => "remove_collection"})
                    haml_concat link_to(c.workspace.name, "#{c.workspace.project ? project_workspace_path(c.workspace.project, c.workspace) : workspace_path(c.workspace)}")
                  end # li.workspace
                end # entry.collections
              end # ul.workspaces
            end # if entry.collections.exists?
          end # div.meta
        
        end # div.content
        haml_tag :div, :class => "options" do
          haml_concat %{<div class="group user">From <strong>#{entry.by_line(current_user)}</strong></div>}
          haml_concat %{<div class="group">#{time_ago_in_words(entry.created_at)} ago</div>}
        end
      end # div.entry
    end
  end
end
