# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_06_085337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.string "answer", default: "-", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_answers_on_event_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.date "date", null: false
    t.time "starttime"
    t.time "finishtime"
    t.string "place", null: false
    t.text "remarks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_events_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "introduction", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "adminuser_id"
    t.string "image"
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "joins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "level", default: 1, null: false
    t.text "content"
    t.index ["group_id"], name: "index_joins_on_group_id"
    t.index ["user_id"], name: "index_joins_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "answers", "events"
  add_foreign_key "answers", "users"
  add_foreign_key "events", "groups"
  add_foreign_key "joins", "groups"
  add_foreign_key "joins", "users"
end
