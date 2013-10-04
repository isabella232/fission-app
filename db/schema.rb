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

ActiveRecord::Schema.define(version: 20130921165033) do

  create_table "account_emails", force: true do |t|
    t.text     "email",      null: false
    t.integer  "account_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_emails", ["account_id", "email"], name: "index_account_emails_on_account_id_and_email", unique: true, using: :btree

  create_table "account_permissions", force: true do |t|
    t.integer  "account_id",    null: false
    t.integer  "permission_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_permissions", ["account_id", "permission_id"], name: "index_account_permissions_on_account_id_and_permission_id", unique: true, using: :btree

  create_table "account_users", force: true do |t|
    t.integer  "account_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_users", ["account_id", "user_id"], name: "index_account_users_on_account_id_and_user_id", unique: true, using: :btree
  add_index "account_users", ["user_id"], name: "index_account_users_on_user_id", using: :btree

  create_table "accounts", force: true do |t|
    t.text     "name",       null: false
    t.text     "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_consumers", force: true do |t|
    t.text     "key",                       null: false
    t.text     "secret",                    null: false
    t.boolean  "enabled",    default: true, null: false
    t.datetime "expires"
    t.integer  "account_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_consumers", ["account_id", "key"], name: "index_api_consumers_on_account_id_and_key", unique: true, using: :btree

  create_table "api_tokens", force: true do |t|
    t.text     "key",                            null: false
    t.text     "secret",                         null: false
    t.datetime "expires"
    t.boolean  "enabled",         default: true, null: false
    t.integer  "api_consumer_id",                null: false
    t.integer  "user_id",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_tokens", ["api_consumer_id", "key"], name: "index_api_tokens_on_api_consumer_id_and_key", unique: true, using: :btree
  add_index "api_tokens", ["user_id"], name: "index_api_tokens_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.text     "unique_id",       null: false
    t.text     "provider",        null: false
    t.text     "name"
    t.text     "email"
    t.text     "nickname"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "location"
    t.text     "description"
    t.text     "image"
    t.text     "phone"
    t.text     "password"
    t.text     "password_digest"
    t.integer  "user_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id", "provider", "unique_id"], name: "index_identities_on_user_id_and_provider_and_unique_id", unique: true, using: :btree
  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "jobs", force: true do |t|
    t.text     "token",      null: false
    t.integer  "user_id"
    t.integer  "account_id"
    t.text     "uuid",       null: false
    t.text     "location",   null: false
    t.text     "state",      null: false
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["uuid"], name: "index_jobs_on_uuid", using: :btree

  create_table "permissions", force: true do |t|
    t.text     "name",        null: false
    t.text     "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_emails", force: true do |t|
    t.text     "email",      null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_emails", ["user_id", "email"], name: "index_user_emails_on_user_id_and_email", unique: true, using: :btree

  create_table "user_permissions", force: true do |t|
    t.integer  "user_id",       null: false
    t.integer  "permission_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_permissions", ["user_id", "permission_id"], name: "index_user_permissions_on_user_id_and_permission_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.text     "username",        null: false
    t.text     "alias"
    t.text     "name"
    t.integer  "base_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
