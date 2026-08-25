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

ActiveRecord::Schema[8.1].define(version: 2026_08_25_115419) do
  create_table "baskets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "max_dose"
    t.float "min_dose"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "beans", force: :cascade do |t|
    t.boolean "archived"
    t.datetime "created_at", null: false
    t.text "description"
    t.date "freeze_date"
    t.date "frozen_on"
    t.string "name"
    t.text "notes"
    t.integer "position"
    t.date "roast_date"
    t.string "roastery"
    t.datetime "updated_at", null: false
  end

  create_table "brews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "dose"
    t.float "grind"
    t.string "rating"
    t.integer "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_brews_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.boolean "archived", default: false
    t.integer "basket_id", null: false
    t.integer "bean_id", null: false
    t.datetime "created_at", null: false
    t.string "style"
    t.string "target_ratio"
    t.datetime "updated_at", null: false
    t.index ["basket_id"], name: "index_recipes_on_basket_id"
    t.index ["bean_id"], name: "index_recipes_on_bean_id"
  end

  add_foreign_key "brews", "recipes"
  add_foreign_key "recipes", "baskets"
  add_foreign_key "recipes", "beans"
end
