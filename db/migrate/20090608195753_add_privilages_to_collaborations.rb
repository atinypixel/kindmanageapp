class AddPrivilagesToCollaborations < ActiveRecord::Migration
  def self.up
    add_column :collaborations, :privilages, :text
  end

  def self.down
    remove_column :collaborations, :privilages
  end
end
