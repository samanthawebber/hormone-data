# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_02_25_070500) do
  create_table "studies", force: :cascade do |t|
    t.string "title", null: false
    t.string "topic"
    t.text "description", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.index ["slug"], name: "index_studies_on_slug", unique: true
    t.index ["user_id"], name: "index_studies_on_user_id"
  end

  create_table "study_parameters", force: :cascade do |t|
    t.integer "study_id", null: false
    t.string "name", null: false
    t.string "unit"
    t.decimal "min_value", precision: 10, scale: 2
    t.decimal "max_value", precision: 10, scale: 2
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_id"], name: "index_study_parameters_on_study_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "study_id", null: false
    t.integer "user_id", null: false
    t.text "values", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["study_id", "created_at"], name: "index_submissions_on_study_id_and_created_at"
    t.index ["study_id"], name: "index_submissions_on_study_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_token", null: false
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "studies", "users"
  add_foreign_key "study_parameters", "studies"
  add_foreign_key "submissions", "studies"
  add_foreign_key "submissions", "users"
end
