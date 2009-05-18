class AddSalt < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :salt, :null => false, :limit => 32, :default => ''
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :salt
    end
  end
end
