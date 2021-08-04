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

ActiveRecord::Schema.define(version: 2021_08_04_125611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appartments", force: :cascade do |t|
    t.bigint "filter_id"
    t.string "external_id"
    t.string "url"
    t.integer "cost"
    t.integer "common_expenses"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.integer "floor"
    t.string "orientation"
    t.integer "useful_surface"
    t.integer "total_surface"
    t.float "latitude"
    t.float "longitude"
    t.date "published"
    t.boolean "sold_out"
    t.date "sold_date"
    t.boolean "rejected"
    t.string "reject_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "duplex"
    t.boolean "walk_in_closet"
    t.index ["external_id"], name: "index_appartments_on_external_id", unique: true
    t.index ["filter_id"], name: "index_appartments_on_filter_id"
  end

  create_table "filters", force: :cascade do |t|
    t.string "url"
    t.string "commune"
    t.string "bedrooms_range"
    t.string "bathrooms_range"
    t.string "price_range"
    t.string "useful_surface_range"
    t.boolean "parking"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visit_comments", force: :cascade do |t|
    t.bigint "appartment_id"
    t.datetime "visit_date_time"
    t.string "contact"
    t.string "address"
    t.string "extra_comments"
    t.integer "elevator_status"
    t.integer "balcony"
    t.integer "view"
    t.integer "water_key_status"
    t.integer "water_pressure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appartment_id"], name: "index_visit_comments_on_appartment_id"
  end

  add_foreign_key "appartments", "filters"
  add_foreign_key "visit_comments", "appartments"
end
