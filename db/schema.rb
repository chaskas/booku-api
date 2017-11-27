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

ActiveRecord::Schema.define(version: 20171127171636) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "arrival"
    t.datetime "departure"
    t.integer "subtotal"
    t.integer "discount"
    t.integer "adults"
    t.integer "childrens"
    t.bigint "client_id"
    t.bigint "place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total"
    t.bigint "user_id", default: 0
    t.string "notes"
    t.index ["client_id"], name: "index_bookings_on_client_id"
    t.index ["place_id"], name: "index_bookings_on_place_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "rut"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "address"
    t.string "city"
    t.string "phone"
    t.string "car_license"
    t.string "car_brand"
    t.string "car_model"
    t.string "car_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount"
    t.integer "method"
    t.integer "bill"
    t.bigint "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.bigint "ptype_id"
    t.integer "capacity"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "extra_night"
    t.integer "extra_passenger"
    t.integer "dsep"
    t.integer "display_order"
    t.index ["ptype_id"], name: "index_places_on_ptype_id"
  end

  create_table "ptypes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "plural"
    t.integer "schedule_type", default: 0
    t.datetime "opening"
    t.datetime "closing"
  end

  create_table "statements", force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "status_id"
    t.index ["booking_id"], name: "index_statements_on_booking_id"
    t.index ["status_id"], name: "index_statements_on_status_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "bookings", "clients"
  add_foreign_key "bookings", "places"
  add_foreign_key "bookings", "users"
  add_foreign_key "payments", "bookings"
  add_foreign_key "places", "ptypes"
  add_foreign_key "statements", "bookings"
  add_foreign_key "statements", "statuses"
end
