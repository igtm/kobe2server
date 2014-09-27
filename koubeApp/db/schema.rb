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

ActiveRecord::Schema.define(version: 20140927171028) do

  create_table "contents", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.string   "category_disp"
    t.text     "content"
    t.integer  "favorite_count"
    t.string   "image"
    t.boolean  "imageFlag"
    t.string   "site_url"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "distance_km"
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

  create_table "varieties", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.text     "content"
    t.integer  "favorite_count"
    t.boolean  "imageFlag"
    t.string   "image"
    t.string   "site_url"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "distance_km"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "yahoos", force: true do |t|
    t.string   "title"
    t.string   "categoryDetail"
    t.string   "category"
    t.string   "category_disp"
    t.float    "shoplon"
    t.float    "shoplat"
    t.text     "image"
    t.boolean  "imageFlag"
    t.text     "uid"
    t.float    "distance_km"
    t.float    "rate"
    t.integer  "rank"
    t.string   "db_output"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
