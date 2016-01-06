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

ActiveRecord::Schema.define(version: 20160106144454) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "order_index"
    t.string  "name"
    t.text    "comment"
    t.string  "link_description"
    t.text    "link_url"
    t.string  "mongo_id"
    t.integer "day_id"
    t.integer "amount_cents",     default: 0,     null: false
    t.string  "amount_currency",  default: "RUB", null: false
  end

  add_index "activities", ["day_id"], name: "index_activities_on_day_id", using: :btree
  add_index "activities", ["order_index"], name: "index_activities_on_order_index", using: :btree

  create_table "adm3_translations", force: :cascade do |t|
    t.integer  "adm3_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "adm3_translations", ["adm3_id"], name: "index_adm3_translations_on_adm3_id", using: :btree
  add_index "adm3_translations", ["locale"], name: "index_adm3_translations_on_locale", using: :btree

  create_table "adm3s", force: :cascade do |t|
    t.string  "geonames_code"
    t.date    "geonames_modification_date"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "population"
    t.string  "country_code"
    t.string  "region_code"
    t.string  "district_code"
    t.string  "adm3_code"
    t.string  "adm4_code"
    t.string  "adm5_code"
    t.string  "timezone"
    t.string  "mongo_id"
  end

  add_index "adm3s", ["geonames_code"], name: "index_adm3s_on_geonames_code", using: :btree
  add_index "adm3s", ["population"], name: "index_adm3s_on_population", using: :btree

  create_table "adm4_translations", force: :cascade do |t|
    t.integer  "adm4_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "adm4_translations", ["adm4_id"], name: "index_adm4_translations_on_adm4_id", using: :btree
  add_index "adm4_translations", ["locale"], name: "index_adm4_translations_on_locale", using: :btree

  create_table "adm4s", force: :cascade do |t|
    t.string  "geonames_code"
    t.date    "geonames_modification_date"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "population"
    t.string  "country_code"
    t.string  "region_code"
    t.string  "district_code"
    t.string  "adm3_code"
    t.string  "adm4_code"
    t.string  "adm5_code"
    t.string  "timezone"
    t.string  "mongo_id"
  end

  add_index "adm4s", ["geonames_code"], name: "index_adm4s_on_geonames_code", using: :btree
  add_index "adm4s", ["population"], name: "index_adm4s_on_population", using: :btree

  create_table "adm5_translations", force: :cascade do |t|
    t.integer  "adm5_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "adm5_translations", ["adm5_id"], name: "index_adm5_translations_on_adm5_id", using: :btree
  add_index "adm5_translations", ["locale"], name: "index_adm5_translations_on_locale", using: :btree

  create_table "adm5s", force: :cascade do |t|
    t.string  "geonames_code"
    t.date    "geonames_modification_date"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "population"
    t.string  "country_code"
    t.string  "region_code"
    t.string  "district_code"
    t.string  "adm3_code"
    t.string  "adm4_code"
    t.string  "adm5_code"
    t.string  "timezone"
    t.string  "mongo_id"
  end

  add_index "adm5s", ["geonames_code"], name: "index_adm5s_on_geonames_code", using: :btree
  add_index "adm5s", ["population"], name: "index_adm5s_on_population", using: :btree

  create_table "caterings", force: :cascade do |t|
    t.text    "description"
    t.integer "days_count"
    t.integer "persons_count"
    t.integer "trip_id"
    t.integer "amount_cents",    default: 0,     null: false
    t.string  "amount_currency", default: "RUB", null: false
    t.integer "order_index"
    t.string  "name"
  end

  add_index "caterings", ["trip_id"], name: "index_caterings_on_trip_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string  "geonames_code"
    t.date    "geonames_modification_date"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "population"
    t.string  "country_code"
    t.string  "region_code"
    t.string  "district_code"
    t.string  "adm3_code"
    t.string  "adm4_code"
    t.string  "adm5_code"
    t.string  "timezone"
    t.string  "status"
    t.string  "mongo_id"
  end

  add_index "cities", ["geonames_code"], name: "index_cities_on_geonames_code", using: :btree
  add_index "cities", ["population"], name: "index_cities_on_population", using: :btree

  create_table "city_translations", force: :cascade do |t|
    t.integer  "city_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "city_translations", ["city_id"], name: "index_city_translations_on_city_id", using: :btree
  add_index "city_translations", ["locale"], name: "index_city_translations_on_locale", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string  "geonames_code"
    t.date    "geonames_modification_date"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "population"
    t.string  "country_code"
    t.string  "region_code"
    t.string  "district_code"
    t.string  "adm3_code"
    t.string  "adm4_code"
    t.string  "adm5_code"
    t.string  "timezone"
    t.string  "iso_code"
    t.string  "iso3_code"
    t.string  "iso_numeric_code"
    t.integer "area"
    t.string  "currency_code"
    t.string  "currency_text"
    t.text    "languages",                  default: [], array: true
    t.string  "continent"
    t.string  "mongo_id"
  end

  add_index "countries", ["geonames_code"], name: "index_countries_on_geonames_code", using: :btree
  add_index "countries", ["population"], name: "index_countries_on_population", using: :btree

  create_table "country_translations", force: :cascade do |t|
    t.integer  "country_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "country_translations", ["country_id"], name: "index_country_translations_on_country_id", using: :btree
  add_index "country_translations", ["locale"], name: "index_country_translations_on_locale", using: :btree

  create_table "days", force: :cascade do |t|
    t.string  "mongo_id"
    t.date    "date_when"
    t.text    "comment"
    t.integer "trip_id"
    t.integer "index"
  end

  add_index "days", ["trip_id"], name: "index_days_on_trip_id", using: :btree

  create_table "district_translations", force: :cascade do |t|
    t.integer  "district_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
  end

  add_index "district_translations", ["district_id"], name: "index_district_translations_on_district_id", using: :btree
  add_index "district_translations", ["locale"], name: "index_district_translations_on_locale", using: :btree

  create_table "districts", force: :cascade do |t|
    t.string  "geonames_code"
    t.date    "geonames_modification_date"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "population"
    t.string  "country_code"
    t.string  "region_code"
    t.string  "district_code"
    t.string  "adm3_code"
    t.string  "adm4_code"
    t.string  "adm5_code"
    t.string  "timezone"
    t.string  "mongo_id"
  end

  add_index "districts", ["geonames_code"], name: "index_districts_on_geonames_code", using: :btree
  add_index "districts", ["population"], name: "index_districts_on_population", using: :btree

  create_table "exchange_rates", force: :cascade do |t|
    t.text     "eu_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "rates_date"
  end

  create_table "expenses", force: :cascade do |t|
    t.string  "name"
    t.string  "mongo_id"
    t.integer "expendable_id"
    t.string  "expendable_type"
    t.integer "amount_cents",    default: 0,     null: false
    t.string  "amount_currency", default: "RUB", null: false
  end

  add_index "expenses", ["expendable_type", "expendable_id"], name: "index_expenses_on_expendable_type_and_expendable_id", using: :btree

  create_table "external_links", force: :cascade do |t|
    t.string  "description"
    t.text    "url"
    t.string  "mongo_id"
    t.integer "linkable_id"
    t.string  "linkable_type"
  end

  add_index "external_links", ["linkable_type", "linkable_id"], name: "index_external_links_on_linkable_type_and_linkable_id", using: :btree

  create_table "hotels", force: :cascade do |t|
    t.string  "name"
    t.text    "comment"
    t.string  "mongo_id"
    t.integer "day_id"
    t.integer "amount_cents",    default: 0,     null: false
    t.string  "amount_currency", default: "RUB", null: false
  end

  add_index "hotels", ["day_id"], name: "index_hotels_on_day_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string  "mongo_id"
    t.integer "day_id"
    t.integer "city_id"
  end

  add_index "places", ["city_id"], name: "index_places_on_city_id", using: :btree
  add_index "places", ["day_id"], name: "index_places_on_day_id", using: :btree

  create_table "region_translations", force: :cascade do |t|
    t.integer  "region_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "region_translations", ["locale"], name: "index_region_translations_on_locale", using: :btree
  add_index "region_translations", ["region_id"], name: "index_region_translations_on_region_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string  "geonames_code"
    t.date    "geonames_modification_date"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "population"
    t.string  "country_code"
    t.string  "region_code"
    t.string  "district_code"
    t.string  "adm3_code"
    t.string  "adm4_code"
    t.string  "adm5_code"
    t.string  "timezone"
    t.string  "mongo_id"
  end

  add_index "regions", ["geonames_code"], name: "index_regions_on_geonames_code", using: :btree
  add_index "regions", ["population"], name: "index_regions_on_population", using: :btree

  create_table "transfers", force: :cascade do |t|
    t.integer  "order_index"
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
    t.string   "mongo_id"
    t.integer  "day_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "RUB", null: false
    t.integer  "city_to_id"
    t.integer  "city_from_id"
  end

  add_index "transfers", ["city_from_id"], name: "index_transfers_on_city_from_id", using: :btree
  add_index "transfers", ["city_to_id"], name: "index_transfers_on_city_to_id", using: :btree
  add_index "transfers", ["day_id"], name: "index_transfers_on_day_id", using: :btree
  add_index "transfers", ["order_index"], name: "index_transfers_on_order_index", using: :btree

  create_table "trip_invites", force: :cascade do |t|
    t.integer "inviting_user_id"
    t.integer "invited_user_id"
    t.integer "trip_id"
  end

  add_index "trip_invites", ["invited_user_id"], name: "index_trip_invites_on_invited_user_id", using: :btree
  add_index "trip_invites", ["inviting_user_id"], name: "index_trip_invites_on_inviting_user_id", using: :btree
  add_index "trip_invites", ["trip_id"], name: "index_trip_invites_on_trip_id", using: :btree

  create_table "trips", force: :cascade do |t|
    t.string   "name"
    t.text     "short_description"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "archived",           default: false
    t.text     "comment"
    t.integer  "budget_for",         default: 1
    t.boolean  "private",            default: false
    t.string   "image_uid"
    t.string   "status_code",        default: "0_draft"
    t.integer  "author_user_id"
    t.string   "mongo_id"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "currency"
    t.boolean  "dates_unknown",      default: false
    t.integer  "planned_days_count"
  end

  add_index "trips", ["author_user_id"], name: "index_trips_on_author_user_id", using: :btree

  create_table "users", force: :cascade do |t|
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
    t.string   "locale"
    t.string   "image_uid"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.integer  "home_town_id"
  end

  add_index "users", ["home_town_id"], name: "index_users_on_home_town_id", using: :btree

  create_table "users_trips", id: false, force: :cascade do |t|
    t.integer "trip_id"
    t.integer "user_id"
  end

  add_index "users_trips", ["trip_id"], name: "index_users_trips_on_trip_id", using: :btree
  add_index "users_trips", ["user_id"], name: "index_users_trips_on_user_id", using: :btree

  add_foreign_key "places", "cities"
end
