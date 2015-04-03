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

ActiveRecord::Schema.define(version: 20150403100126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "days", force: true do |t|
    t.string  "mongo_id"
    t.date    "date_when"
    t.text    "comment"
    t.integer "trip_id"
  end

  add_index "days", ["trip_id"], name: "index_days_on_trip_id", using: :btree

  create_table "expenses", force: true do |t|
    t.string  "name"
    t.integer "price"
    t.string  "mongo_id"
    t.integer "expendable_id"
    t.string  "expendable_type"
  end

  add_index "expenses", ["expendable_id", "expendable_type"], name: "index_expenses_on_expendable_id_and_expendable_type", using: :btree

  create_table "places", force: true do |t|
    t.string  "city_code"
    t.string  "city_text"
    t.string  "mongo_id"
    t.integer "day_id"
  end

  add_index "places", ["day_id"], name: "index_places_on_day_id", using: :btree

  create_table "transfers", force: true do |t|
    t.integer  "order_index"
    t.string   "city_from_code"
    t.string   "city_from_text"
    t.string   "city_to_code"
    t.string   "city_to_text"
    t.string   "type"
    t.string   "type_icon"
    t.string   "code"
    t.string   "company"
    t.string   "link"
    t.string   "station_from"
    t.string   "station_to"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "comment"
    t.integer  "price"
    t.string   "mongo_id"
    t.integer  "day_id"
  end

  add_index "transfers", ["day_id"], name: "index_transfers_on_day_id", using: :btree

  create_table "trips", force: true do |t|
    t.string   "name"
    t.text     "short_description"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "archived",          default: false
    t.text     "comment"
    t.integer  "budget_for",        default: 1
    t.boolean  "private",           default: false
    t.string   "image_uid"
    t.string   "status_code",       default: "0_draft"
    t.integer  "author_user_id"
    t.string   "mongo_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "trips", ["author_user_id"], name: "index_trips_on_author_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "home_town_code"
    t.string   "home_town_text"
    t.string   "locale"
    t.string   "image_uid"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_trips", id: false, force: true do |t|
    t.integer "trip_id"
    t.integer "user_id"
  end

  add_index "users_trips", ["trip_id"], name: "index_users_trips_on_trip_id", using: :btree
  add_index "users_trips", ["user_id"], name: "index_users_trips_on_user_id", using: :btree

end
