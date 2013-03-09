# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121118170502) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "old_id"
    t.integer  "new_id"
    t.text     "xml"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "tag"
    t.text     "response"
    t.integer  "transfer_id"
    t.text     "notes"
  end

  create_table "deal_categories", :force => true do |t|
    t.string   "name"
    t.integer  "new_id"
    t.integer  "old_id"
    t.text     "xml"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "transfer_id"
    t.text     "response"
  end

  create_table "deals", :force => true do |t|
    t.text     "name"
    t.integer  "old_id"
    t.integer  "new_id"
    t.text     "xml"
    t.text     "response"
    t.integer  "transfer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "parties"
    t.text     "notes"
  end

  create_table "kases", :force => true do |t|
    t.string   "name"
    t.integer  "new_id"
    t.integer  "old_id"
    t.text     "response"
    t.integer  "transfer_id"
    t.text     "xml"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "notes"
  end

  create_table "notes", :force => true do |t|
    t.text     "body"
    t.text     "xml"
    t.text     "response"
    t.integer  "transfer_id"
    t.integer  "new_id"
    t.integer  "old_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "old_id"
    t.integer  "new_id"
    t.integer  "company_id"
    t.text     "tag"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "xml"
    t.text     "response"
    t.integer  "transfer_id"
    t.text     "notes"
  end

  create_table "task_categories", :force => true do |t|
    t.string   "name"
    t.integer  "new_id"
    t.integer  "old_id"
    t.text     "xml"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "transfer_id"
    t.text     "response"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "new_id"
    t.integer  "old_id"
    t.text     "response"
    t.integer  "transfer_id"
    t.text     "xml"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "transfers", :force => true do |t|
    t.string   "source_api_token"
    t.string   "source_url"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "target_api_token"
    t.string   "target_url"
    t.boolean  "migrated_users"
    t.boolean  "performed"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "old_id"
    t.integer  "new_id"
    t.text     "xml"
    t.text     "response"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "transfer_id"
  end

end
