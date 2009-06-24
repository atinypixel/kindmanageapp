class AddUserIdToCollaborationsTable < ActiveRecord::Migration
  def self.up
    add_column :collaborations, :user_id, :integer
  end

  def self.down
    remove_column :collaborations, :user_id
  end
end
