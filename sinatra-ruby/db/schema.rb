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

ActiveRecord::Schema.define(version: 2022_08_03_114106) do

  create_table "actions", force: :cascade do |t|
    t.string "status"
    t.string "code"
    t.string "description_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "multiple", default: false
    t.json "authorizations", default: []
  end

  create_table "connections", force: :cascade do |t|
    t.string "user_id"
    t.string "public_key", limit: 4096
    t.string "push_token", limit: 4096
    t.string "platform", limit: 32
    t.string "return_url", limit: 4096
    t.string "connect_session_token", limit: 4096
    t.string "access_token", limit: 4096
    t.boolean "revoked", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "consents", force: :cascade do |t|
    t.string "connection_id"
    t.string "user_id"
    t.string "consent_type"
    t.string "tpp_name"
    t.string "accounts", default: "[]"
    t.boolean "balance", default: false
    t.boolean "transactions", default: false
    t.datetime "expires_at"
    t.boolean "revoked", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
