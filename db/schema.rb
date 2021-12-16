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

ActiveRecord::Schema.define(version: 2021_12_16_055958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "children", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "parent_id", null: false
    t.string "name", null: false
    t.date "dob", null: false
    t.string "gender", null: false
    t.string "school_class"
    t.string "school_grade"
    t.uuid "school_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "drive_request_id"
    t.index ["drive_request_id"], name: "index_children_on_drive_request_id"
    t.index ["parent_id"], name: "index_children_on_parent_id"
    t.index ["school_id"], name: "index_children_on_school_id"
  end

  create_table "drive_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "school_id", null: false
    t.uuid "parent_id", null: false
    t.string "status", default: "pending", null: false
    t.boolean "round_trip", default: false, null: false
    t.string "pickup_coords"
    t.string "drop_coords"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_drive_requests_on_parent_id"
    t.index ["school_id"], name: "index_drive_requests_on_school_id"
  end

  create_table "drivers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "dob", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_drivers_on_user_id"
  end

  create_table "parents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_parents_on_user_id"
  end

  create_table "schools", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "a_name", null: false
    t.string "e_name", null: false
    t.string "lat", null: false
    t.string "long", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "otp"
    t.string "code"
    t.string "phone_no"
    t.datetime "expires_in"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phone_no"], name: "index_tokens_on_phone_no", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "phone_no", null: false
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "refresh_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_no"], name: "index_users_on_phone_no", unique: true
    t.index ["refresh_token"], name: "index_users_on_refresh_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "children", "drive_requests"
  add_foreign_key "children", "parents"
  add_foreign_key "children", "schools"
  add_foreign_key "drive_requests", "parents"
  add_foreign_key "drive_requests", "schools"
  add_foreign_key "drivers", "users"
  add_foreign_key "parents", "users"
end
