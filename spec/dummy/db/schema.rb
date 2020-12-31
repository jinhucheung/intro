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

ActiveRecord::Schema.define(version: 2020_12_31_044619) do

  create_table "intro_tour_histories", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.integer "user_id", null: false
    t.integer "touch_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "tour_id", "touch_count"], name: "index_intro_tour_histories_on_user_and_tour_and_touch_count"
  end

  create_table "intro_tours", force: :cascade do |t|
    t.string "ident", null: false
    t.string "controller_path", default: "", null: false
    t.string "action_name", default: "", null: false
    t.text "route"
    t.text "options"
    t.boolean "published", default: false
    t.datetime "expired_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["controller_path", "action_name", "published"], name: "index_intro_tours_on_controller_and_action_and_published"
    t.index ["ident"], name: "index_intro_tours_on_ident", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
