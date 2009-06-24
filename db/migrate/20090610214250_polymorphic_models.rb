class PolymorphicModels < ActiveRecord::Migration
  def self.up
    add_column :entries, :content_id, :integer
    add_column :entries, :content_type, :string
    
  end

  def self.down
    remove_column :entries, :content_type
    remove_column :entries, :content_id
  end
end
