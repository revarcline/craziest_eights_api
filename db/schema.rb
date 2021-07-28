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

ActiveRecord::Schema.define(version: 2021_07_28_003544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "rank"
    t.string "suit"
    t.bigint "deck_id", null: false
    t.bigint "pile_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_cards_on_deck_id"
    t.index ["pile_id"], name: "index_cards_on_pile_id"
  end

  create_table "decks", force: :cascade do |t|
    t.integer "number", default: 1
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_decks_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.integer "turn"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "piles", force: :cascade do |t|
    t.string "role"
    t.bigint "deck_id", null: false
    t.bigint "player_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deck_id"], name: "index_piles_on_deck_id"
    t.index ["player_id"], name: "index_piles_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.boolean "is_ai"
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_players_on_game_id"
  end

  add_foreign_key "cards", "decks"
  add_foreign_key "cards", "piles"
  add_foreign_key "decks", "games"
  add_foreign_key "piles", "decks"
  add_foreign_key "piles", "players"
  add_foreign_key "players", "games"
end
