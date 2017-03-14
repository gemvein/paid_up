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

ActiveRecord::Schema.define(version: 20170220001913) do

  create_table "doodads", force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.text   "description"
    t.index ["user_id"], name: "index_doodads_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: false, null: false
    t.index ["active"], name: "index_groups_on_active"
  end

  create_table "paid_up_plan_feature_settings", force: :cascade do |t|
    t.integer "paid_up_plan_id"
    t.string  "feature"
    t.integer "setting"
    t.index ["feature"], name: "index_paid_up_plan_feature_settings_on_feature"
    t.index ["paid_up_plan_id"], name: "index_paid_up_plan_feature_settings_on_paid_up_plan_id"
  end

  create_table "paid_up_plans", force: :cascade do |t|
    t.string   "stripe_id"
    t.string   "title"
    t.text     "description"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["stripe_id"], name: "index_paid_up_plans_on_stripe_id", unique: true
    t.index ["title"], name: "index_paid_up_plans_on_title", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string   "user_id"
    t.string   "title"
    t.boolean  "active",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["active"], name: "index_posts_on_active"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

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
    t.string   "coupon_code"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

end
