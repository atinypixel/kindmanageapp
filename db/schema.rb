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

ActiveRecord::Schema.define(:version => 20090502085212) do

  create_table "accounts", :force => true do |t|
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", :force => true do |t|
    t.integer  "entry_id"
    t.integer  "workspace_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "private"
    t.integer  "milestone_id"
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
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "accounts_id"
  end

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
