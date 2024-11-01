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

ActiveRecord::Schema[7.1].define(version: 2024_10_11_090159) do
  create_table "cards", force: :cascade do |t|
    t.string "up"
    t.string "down"
    t.string "left"
    t.string "right"
    t.string "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id", null: false
    t.integer "up_points"
    t.integer "down_points"
    t.integer "right_points"
    t.integer "left_points"
    t.string "name"
    t.string "image"
    t.integer "copy", default: 0
    t.boolean "max", default: false
    t.boolean "new", default: true
    t.index ["player_id"], name: "index_cards_on_player_id"
  end

  create_table "elites", force: :cascade do |t|
    t.string "up"
    t.string "down"
    t.string "left"
    t.string "right"
    t.string "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id", null: false
    t.boolean "in_deck", default: false
    t.string "name"
    t.integer "fight", default: 0
    t.integer "diplomacy", default: 0
    t.integer "espionage", default: 0
    t.integer "leadership", default: 0
    t.boolean "potential", default: false
    t.boolean "nft", default: false
    t.boolean "in_sale", default: false
    t.integer "price", default: 0
    t.index ["player_id"], name: "index_elites_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id", null: false
    t.integer "rounds", default: 1
    t.integer "player_points", default: 0
    t.integer "computer_points", default: 0
    t.boolean "turn"
    t.string "logs", default: "[]"
    t.string "monsters", default: "[]"
    t.boolean "boss", default: false
    t.index ["player_id"], name: "index_games_on_player_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zones", default: "[]"
    t.integer "up"
    t.integer "down"
    t.integer "right"
    t.integer "left"
    t.integer "rank"
    t.string "rules", default: "[]"
    t.string "name"
    t.string "image"
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
    t.boolean "hide", default: true
    t.boolean "pvp", default: false
    t.index ["player_id"], name: "index_player_cards_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "wallet_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "decks", default: "[]"
    t.boolean "in_game", default: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "authentication_token", limit: 30
    t.boolean "power", default: false
    t.integer "power_point", default: 0
    t.boolean "computer_power", default: false
    t.integer "computer_power_point", default: 0
    t.string "ability"
    t.string "computer_ability"
    t.string "zone_position", default: "A1"
    t.string "zones", default: "[]"
    t.string "monsters", default: "[]"
    t.integer "energy", default: 0
    t.integer "elite_points", default: 0
    t.string "in_pvp", default: "false"
    t.boolean "pvp_power", default: false
    t.integer "pvp_power_point", default: 0
    t.boolean "b_zone", default: false
    t.boolean "s_zone", default: false
    t.string "s_monsters", default: "[]"
    t.string "power_condition"
    t.string "monster_condition"
    t.boolean "bonus", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["authentication_token"], name: "index_players_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["id"], name: "index_players_on_id"
    t.index ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true
  end

  create_table "pnj_objectives", force: :cascade do |t|
    t.integer "pnj_id", null: false
    t.string "name"
    t.string "condition"
    t.boolean "completed", default: false
    t.boolean "reveal", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pnj_id"], name: "index_pnj_objectives_on_pnj_id"
  end

  create_table "pnjs", force: :cascade do |t|
    t.integer "try", default: 0
    t.integer "victory", default: 0
    t.integer "defeat", default: 0
    t.integer "perfect", default: 0
    t.integer "boss", default: 0
    t.integer "awake", default: 0
    t.string "zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id", null: false
    t.string "dialogue", default: "[]"
    t.string "name"
    t.string "zone_image"
    t.index ["player_id"], name: "index_pnjs_on_player_id"
  end

  create_table "pvps", force: :cascade do |t|
    t.integer "player1_id", null: false
    t.integer "player2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rounds", default: 1
    t.integer "player1_points", default: 0
    t.integer "player2_points", default: 0
    t.integer "turn"
    t.string "logs", default: "[]"
    t.string "monsters", default: "[]"
    t.boolean "finish1", default: false
    t.boolean "finish2", default: false
    t.index ["player1_id"], name: "index_pvps_on_player1_id"
    t.index ["player2_id"], name: "index_pvps_on_player2_id"
  end

  add_foreign_key "cards", "players"
  add_foreign_key "elites", "players"
  add_foreign_key "games", "players"
  add_foreign_key "player_cards", "players"
  add_foreign_key "pnj_objectives", "pnjs"
  add_foreign_key "pnjs", "players"
  add_foreign_key "pvps", "players", column: "player1_id"
  add_foreign_key "pvps", "players", column: "player2_id"
end
