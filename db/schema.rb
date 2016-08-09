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

ActiveRecord::Schema.define(version: 20160805035712) do

  create_table "checkins", force: :cascade do |t|
    t.integer "user_id"
    t.integer "location_id"
  end

  add_index "checkins", ["location_id"], name: "index_checkins_on_location_id"
  add_index "checkins", ["user_id"], name: "index_checkins_on_user_id"

  create_table "interactions", force: :cascade do |t|
    t.integer  "user_one_id"
    t.integer  "user_two_id"
    t.boolean  "like"
    t.boolean  "matched"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "interactions", ["user_one_id"], name: "index_interactions_on_user_one_id"
  add_index "interactions", ["user_two_id"], name: "index_interactions_on_user_two_id"

  create_table "locations", force: :cascade do |t|
    t.text     "image"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "user_one_id"
    t.integer  "user_two_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "token"
  end

  add_index "matches", ["user_one_id"], name: "index_matches_on_user_one_id"
  add_index "matches", ["user_two_id"], name: "index_matches_on_user_two_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "id_facebook"
    t.string   "token"
    t.string   "password_digest"
    t.boolean  "email_confirmed"
    t.string   "confirm_token"
    t.string   "password_reset_key"
    t.datetime "password_reset_sent_at"
    t.string   "gender"
    t.date     "birthday"
    t.string   "description"
    t.text     "avatar"
    t.boolean  "status",                 default: false
    t.integer  "age"
    t.float    "weight"
    t.float    "height"
    t.string   "city"
    t.string   "district"
    t.boolean  "search_male"
    t.boolean  "search_female"
    t.integer  "search_range"
    t.text     "gallery"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
