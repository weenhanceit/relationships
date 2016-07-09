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

ActiveRecord::Schema.define(version: 20160709022405) do

  create_table "address_people", force: :cascade do |t|
    t.integer  "address_id"
    t.integer  "person_id"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_address_people_on_address_id"
    t.index ["person_id"], name: "index_address_people_on_person_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.text     "line1"
    t.text     "line2"
    t.text     "city"
    t.integer  "province_id"
    t.text     "postal_code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["province_id"], name: "index_addresses_on_province_id"
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "provinces", force: :cascade do |t|
    t.string   "province_code"
    t.string   "province_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
