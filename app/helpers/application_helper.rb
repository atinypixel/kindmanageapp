# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def create_or_update(object)
    object.new_record? ? "create" : "update"
  end
  
  def new_or_edit(object)
    object.new_record? ? "new" : "edit"
  end
  
  # def destroy_note_title_link(name)
  #   link_to_function name, :id => "destroy_note_title_link", :style => "display:none;" do |page|
  #     page.remove "note_title_field"
  #     page.hide "note_title_field_wrapper"
  #     # page.show "add_note_title_link"
  #   end
  # end
  
  def add_note_title_link(name, object)
    link_to_function name, :id => "add_note_title_link" do |page|
      page.show "note_title_field_wrapper"
      page.insert_html :top, "note_title_field_wrapper", :partial => "entries/forms/note_title", :locals => {:f => object}
      page.hide "add_note_title_link"
      page << "$('entry_note_show_title').writeAttribute('value', '1');"
    end
  end
  
  # def remove_note_tiLtle_link(name)
  #   link_to_function name, :id => "remove_note_title_link" do |page|
  #     page.remove ""
  #   end
  # end
  
end
