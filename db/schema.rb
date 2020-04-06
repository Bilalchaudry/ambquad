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

ActiveRecord::Schema.define(version: 2020_04_06_094834) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budget_holders", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "client_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
  end

  create_table "client_companies", force: :cascade do |t|
    t.string "email"
    t.string "company_name"
    t.string "company_id"
    t.string "address"
    t.string "phone"
    t.integer "number_of_users", default: 0
    t.string "primary_poc_first_name"
    t.string "primary_poc_last_name"
    t.string "poc_email"
    t.string "poc_phone"
    t.integer "status"
    t.date "closed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country_name"
    t.string "poc_country"
  end

  create_table "client_company_projects", force: :cascade do |t|
    t.integer "project_id"
    t.integer "client_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cost_codes", force: :cascade do |t|
    t.string "cost_code_id"
    t.string "cost_code_description"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_company_id"
    t.boolean "temporary_close", default: false
    t.integer "budget_holder_id"
  end

  create_table "employee_time_sheets", force: :cascade do |t|
    t.string "employee"
    t.integer "employee_id"
    t.string "labour_type"
    t.integer "employee_type_id"
    t.string "company"
    t.integer "project_company_id"
    t.string "manager"
    t.integer "foreman_id"
    t.float "total_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foreman_name"
    t.date "employee_create_date"
  end

  create_table "employee_types", force: :cascade do |t|
    t.string "employee_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_company_id"
    t.integer "project_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "employee_id"
    t.string "phone"
    t.string "email"
    t.integer "gender", default: 0
    t.text "home_company_role"
    t.date "contract_start_date"
    t.date "contract_end_date"
    t.integer "status", default: 0
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "foreman_id"
    t.bigint "other_manager_id"
    t.bigint "employee_type_id"
    t.bigint "project_company_id"
    t.integer "client_company_id"
    t.string "country_name"
    t.index ["employee_type_id"], name: "index_employees_on_employee_type_id"
    t.index ["foreman_id"], name: "index_employees_on_foreman_id"
    t.index ["other_manager_id"], name: "index_employees_on_other_manager_id"
    t.index ["project_company_id"], name: "index_employees_on_project_company_id"
    t.index ["project_id"], name: "index_employees_on_project_id"
  end

  create_table "foremen", force: :cascade do |t|
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_company_id"
    t.integer "project_id"
    t.index ["employee_id"], name: "index_foremen_on_employee_id"
  end

  create_table "other_managers", force: :cascade do |t|
    t.string "manager_type"
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_company_id"
    t.integer "project_id"
    t.index ["employee_id"], name: "index_other_managers_on_employee_id"
  end

  create_table "plant_time_sheets", force: :cascade do |t|
    t.string "plant_id"
    t.string "plant_name"
    t.string "company"
    t.integer "project_company_id"
    t.string "manager"
    t.integer "foreman_id"
    t.float "total_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foreman_name"
  end

  create_table "plant_types", force: :cascade do |t|
    t.string "type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id"
    t.integer "client_company_id"
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
    t.integer "foreman_id"
    t.integer "other_manager_id"
    t.date "foreman_start_date"
    t.date "foreman_end_date"
    t.boolean "offload", default: false
    t.integer "project_id"
    t.integer "client_company_id"
  end

  create_table "project_and_project_companies", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "project_company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_company_id"], name: "index_project_and_project_companies_on_project_company_id"
    t.index ["project_id"], name: "index_project_and_project_companies_on_project_id"
  end

  create_table "project_companies", force: :cascade do |t|
    t.text "company_summary"
    t.text "project_role"
    t.string "address"
    t.string "phone"
    t.string "primary_poc_first_name"
    t.string "primary_poc_last_name"
    t.string "poc_email"
    t.string "poc_phone"
    t.bigint "client_company_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_name"
    t.string "country_name"
    t.string "poc_country"
    t.index ["client_company_id"], name: "index_project_companies_on_client_company_id"
    t.index ["project_id"], name: "index_project_companies_on_project_id"
  end

  create_table "project_employees", force: :cascade do |t|
    t.date "contract_start_date"
    t.date "contract_end_date"
    t.bigint "employee_id"
    t.bigint "employee_type_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "total_hours"
    t.integer "foreman_id"
    t.integer "other_manager_id"
    t.integer "project_company_id"
    t.index ["employee_id"], name: "index_project_employees_on_employee_id"
    t.index ["employee_type_id"], name: "index_project_employees_on_employee_type_id"
    t.index ["project_id"], name: "index_project_employees_on_project_id"
  end

  create_table "project_project_employees", force: :cascade do |t|
    t.integer "project_id"
    t.integer "project_employee_id"
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
    t.integer "employee_id"
    t.string "project_lead"
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
    t.string "country_name"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
  end

  create_table "time_sheet_cost_codes", force: :cascade do |t|
    t.string "cost_code"
    t.integer "cost_code_id"
    t.float "hrs"
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
    t.string "country_name"
    t.integer "status"
    t.string "confirm_password"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "employees", "employee_types"
  add_foreign_key "employees", "foremen"
  add_foreign_key "employees", "other_managers"
  add_foreign_key "employees", "project_companies"
  add_foreign_key "employees", "projects"
  add_foreign_key "foremen", "employees"
  add_foreign_key "other_managers", "employees"
  add_foreign_key "project_and_project_companies", "project_companies"
  add_foreign_key "project_and_project_companies", "projects"
  add_foreign_key "project_companies", "client_companies"
  add_foreign_key "project_companies", "projects"
  add_foreign_key "project_employees", "employee_types"
  add_foreign_key "project_employees", "employees"
  add_foreign_key "project_employees", "projects"
end
