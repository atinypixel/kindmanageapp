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
end
