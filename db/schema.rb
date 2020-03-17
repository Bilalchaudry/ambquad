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

ActiveRecord::Schema.define(version: 2020_03_17_063228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_companies", force: :cascade do |t|
    t.string "email"
    t.string "company_name"
    t.string "company_id"
    t.string "address"
    t.string "phone"
    t.integer "number_of_users"
    t.string "primary_poc_first_name"
    t.string "primary_poc_last_name"
    t.string "poc_email"
    t.string "poc_phone"
    t.integer "status"
    t.date "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_company_projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "client_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_types", force: :cascade do |t|
    t.string "employee_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plant_types", force: :cascade do |t|
    t.string "type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plants", force: :cascade do |t|
    t.string "plant_name"
    t.string "plant_id"
    t.integer "plant_type_id"
    t.integer "project_company_id"
    t.date "contract_start_date"
    t.date "contract_end_date"
    t.string "market_value"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_name"
    t.string "project_id"
    t.string "site_office_address"
    t.text "project_summary"
    t.text "phone"
    t.date "start_date"
    t.date "end_date"
    t.integer "project_status"
    t.integer "client_company_id"
    t.string "client_po_number"
    t.date "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temporary_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_no"
    t.string "email"
    t.string "username"
    t.integer "role", default: 0
    t.string "encrypted_password"
    t.string "password"
    t.integer "client_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_client_companies", force: :cascade do |t|
    t.integer "user_id"
    t.integer "client_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_no"
    t.string "email", default: "", null: false
    t.string "username"
    t.integer "role", default: 0
    t.string "encrypted_password", default: "", null: false
    t.integer "client_company_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
