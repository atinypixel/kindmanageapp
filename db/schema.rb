# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090423232728) do

  create_table "accounts", :force => true do |t|
    t.string "name",      :limit => 100, :null => false
    t.string "api_token", :limit => 32
  end

  add_index "accounts", ["name"], :name => "index_accounts_on_name"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "entries", :force => true do |t|
    t.text     "note_body"
    t.string   "note_title"
    t.text     "task_description"
    t.datetime "task_due_at"
    t.datetime "task_completed_at"
    t.integer  "type_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "note_show_title"
    t.boolean  "task_show_due_at"
    t.integer  "account_id"
    t.integer  "user_id"
    t.boolean  "in_queue"
    t.integer  "task_milestone_id"
  end

  create_table "milestones", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "user_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "user_id"
  end

  create_table "types", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",                :limit => 16,                 :null => false
    t.string   "last_name",                 :limit => 16,                 :null => false
    t.string   "email",                     :limit => 100,                :null => false
    t.string   "password",                  :limit => 32,                 :null => false
    t.integer  "role",                      :limit => 1,   :default => 1, :null => false
    t.string   "remember_token",            :limit => 32
    t.datetime "remember_token_expires_at"
    t.datetime "deleted_at"
    t.integer  "account_id"
  end

  add_index "users", ["email", "account_id"], :name => "index_users_on_email_and_account_id", :unique => true
  add_index "users", ["email", "password", "account_id", "deleted_at"], :name => "index_users_on_email_and_password_and_account_id_and_deleted_at"
  add_index "users", ["remember_token", "remember_token_expires_at", "account_id", "deleted_at"], :name => "by_remember_token"

  create_table "workspaces", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "user_id"
  end

  create_table "workspaces_entries", :force => true do |t|
    t.integer "workspace_id"
    t.integer "entry_id"
  end

end
