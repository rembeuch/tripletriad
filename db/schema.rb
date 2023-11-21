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

ActiveRecord::Schema[7.1].define(version: 2023_11_21_103326) do
  create_table "cards", force: :cascade do |t|
    t.string "up"
    t.string "down"
    t.string "left"
    t.string "right"
    t.string "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id", null: false
    t.integer "rounds", default: 1
    t.integer "player_points", default: 0
    t.integer "computer_points", default: 0
    t.index ["player_id"], name: "index_games_on_player_id"
  end

  create_table "player_cards", force: :cascade do |t|
    t.string "up"
    t.string "down"
    t.string "right"
    t.string "left"
    t.string "position"
    t.boolean "computer"
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["player_id"], name: "index_player_cards_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "wallet_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "decks", default: "[]"
    t.boolean "in_game", default: false
  end

  add_foreign_key "games", "players"
  add_foreign_key "player_cards", "players"
end
