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

ActiveRecord::Schema.define(version: 20160207184114) do

  create_table "doodads", force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.text   "description"
  end

  add_index "doodads", ["user_id"], name: "index_doodads_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paid_up_plan_feature_settings", force: :cascade do |t|
    t.integer "paid_up_plan_id"
    t.string  "feature"
    t.integer "setting"
  end

  add_index "paid_up_plan_feature_settings", ["feature"], name: "index_paid_up_plan_feature_settings_on_feature"
  add_index "paid_up_plan_feature_settings", ["paid_up_plan_id"], name: "index_paid_up_plan_feature_settings_on_paid_up_plan_id"

  create_table "paid_up_plans", force: :cascade do |t|
    t.string   "stripe_id"
    t.string   "title"
    t.text     "description"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "paid_up_plans", ["stripe_id"], name: "index_paid_up_plans_on_stripe_id", unique: true
  add_index "paid_up_plans", ["title"], name: "index_paid_up_plans_on_title", unique: true

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "stripe_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
