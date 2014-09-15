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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140912080802) do

  create_table "contents", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.text     "content"
    t.integer  "favorite_count"
    t.string   "image"
    t.boolean  "imageFlag"
    t.string   "site_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.float    "current_lat"
    t.float    "current_lon"
    t.text     "favorite_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
