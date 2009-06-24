module EntriesHelper
  def entry_list_item(entry, opt={})
    if project_accessible_by_user?(entry.project, current_user)
      capture_haml do
        haml_tag :div, :class => "entry #{entry.content_type}", :id => "entry_#{entry.id}" do
          # haml_concat %{<div class="content_type"><span>#{entry.content_type}</span></div>}
          haml_tag :div, :class => "content slim" do
            # title
            haml_tag :h3, :class => "title" do
              haml_concat %{<span class="content_type"><span>#{entry.content_type}</span></span>}
              unless @project
                haml_concat link_to(entry.project.name, project_path(entry.project), :class => "owning_project")
              end
              haml_concat link_to(entry.title.gsub(/((?:@[a-zA-z0-9\.\-]+\s*)+)$/, ""), project_entry_path(entry.project, entry))
            end
            # meta
            haml_tag :div, :class => "meta" do
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
          # options
          haml_tag :div, :class => "meta" do
            haml_concat %{<div class="group user">From <strong>#{entry.by_line(current_user)}</strong></div>}
            haml_concat %{<div class="group">#{time_ago_in_words(entry.created_at)} ago</div>}
          end
        end
      end
    end
  end
  
  def entry_item(entry, opt={})
    capture_haml do
      main_content = case entry.content_type
        when "note" then entry.note.body.to_s
        when "task" then entry.task.description.to_s
        when "discussion" then entry.discussion.body
        when "upload" then entry.upload.description
      end
      main_content = main_content.gsub(/((?:@[a-zA-z0-9\.\-]+\s*)+)$/, "")
      haml_tag :div, :class => "form_area", :style => "display:none;"
      haml_tag :div, :class => "entry #{entry.content_type}", :id => "entry_#{entry.id}" do
        haml_tag :div, :class => "content", :id => "content_for_entry_#{entry.id}" do
          # meta
          haml_tag :div, :class => "meta" do
            haml_concat %{<span class="comments#{entry.collections.exists? ? ' separate' : ''}">0 comments</span>}
            if entry.collections.exists?
              haml_tag :ul, :class => "workspaces" do
                entry.collections.reload.each do |c|
                  haml_tag :li, :class => "workspace" do
                    if current_user.owns?(entry)
                      haml_concat link_to_remote(image_tag("trash_icon.png"), :url => collection_path(c, :context => @context), :method => :delete, :confirm => "Are you sure", :html => {:class => "remove_collection"})
                    end
                    haml_concat link_to(c.workspace.name, "#{c.workspace.project ? project_workspace_path(c.workspace.project, c.workspace) : workspace_path(c.workspace)}")
                  end # li.workspace
                end # entry.collections
              end # ul.workspaces
            end # if entry.collections.exists?
          end # div.meta
          
          case entry.content_type
            when "note"
              haml_tag :h3, :class => "title" do
                haml_concat filter_workspaces(entry.content.title)
              end
              haml_tag :div, :class => "body" do
                haml_concat markdown(main_content)
              end
            when "task"
              haml_tag :h3, :class => "title" do
                haml_concat main_content
              end
            when "issue"
              haml_tag :h3, :class => "title" do
                haml_concat main_content
                haml_concat %{<span class="status">open</span>}
              end
            when "discussion"
              haml_tag :h3, :class => "title" do
                haml_concat filter_workspaces(entry.content.subject)
              end
              haml_tag :div, :class => "body" do
                haml_concat markdown(main_content)
              end
            when "upload"
          end # case entry.content_type
          
        
        end # div.content
        haml_tag :div, :class => "meta" do
          haml_concat %{<div class="group user">From <strong>#{entry.by_line(current_user)}</strong></div>}
          haml_concat %{<div class="group">#{time_ago_in_words(entry.created_at)} ago</div>}
        end
      end # div.entry
    end
  end
end
