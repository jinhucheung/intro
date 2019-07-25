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

ActiveRecord::Schema.define(version: 20190706110238) do

  create_table "intro_tour_histories", force: :cascade do |t|
    t.integer  "tour_id",                 null: false
    t.integer  "user_id",                 null: false
    t.integer  "touch_count", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "intro_tour_histories", ["user_id", "tour_id", "touch_count"], name: "index_intro_tour_histories_on_user_and_tour_and_touch_count"

  create_table "intro_tours", force: :cascade do |t|
    t.string   "ident",                           null: false
    t.string   "controller_path", default: "",    null: false
    t.string   "action_name",     default: "",    null: false
    t.text     "route"
    t.text     "options"
    t.boolean  "posted",          default: false
    t.datetime "expired_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "intro_tours", ["controller_path", "action_name", "posted"], name: "index_intro_tours_on_controller_and_action_and_posted"
  add_index "intro_tours", ["ident"], name: "index_intro_tours_on_ident", unique: true

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
