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

ActiveRecord::Schema.define(version: 20160916010735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "interaction_id"
    t.text     "content"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "question_id"
    t.integer  "user_id"
    t.text     "encrypted_answer"
  end

  add_index "answers", ["interaction_id"], name: "index_answers_on_interaction_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "name"
    t.string   "logo"
    t.string   "link"
    t.text     "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goals", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "due_date"
    t.boolean  "completed",          default: false
    t.datetime "completed_date"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "active",             default: true
    t.integer  "interaction_id"
    t.integer  "improvements_count", default: 0
    t.text     "encrypted_goal"
  end

  add_index "goals", ["interaction_id"], name: "index_goals_on_interaction_id", using: :btree
  add_index "goals", ["user_id", "due_date"], name: "index_goals_on_user_id_and_due_date", using: :btree
  add_index "goals", ["user_id"], name: "index_goals_on_user_id", using: :btree

  create_table "improvements", force: :cascade do |t|
    t.integer  "goal_id"
    t.integer  "step_id"
    t.integer  "value",          default: 1
    t.boolean  "unexpected",     default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "interaction_id"
  end

  add_index "improvements", ["goal_id"], name: "index_improvements_on_goal_id", using: :btree
  add_index "improvements", ["interaction_id"], name: "index_improvements_on_interaction_id", using: :btree
  add_index "improvements", ["step_id"], name: "index_improvements_on_step_id", using: :btree

  create_table "interactions", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "completed",  default: false
    t.integer  "feeling"
    t.text     "journal"
  end

  add_index "interactions", ["user_id"], name: "index_interactions_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",     default: false
    t.boolean  "archived",   default: false
    t.integer  "topic_id"
  end

  add_index "questions", ["topic_id"], name: "index_questions_on_topic_id", using: :btree

  create_table "remembers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "remember_digest"
    t.string   "browser"
    t.string   "device"
    t.string   "platform"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "remembers", ["user_id"], name: "index_remembers_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.boolean  "global",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "steps", force: :cascade do |t|
    t.integer  "goal_id"
    t.text     "content"
    t.boolean  "completed",      default: false
    t.datetime "completed_date"
    t.integer  "order"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "steps", ["goal_id"], name: "index_steps_on_goal_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscriptions", ["topic_id"], name: "index_subscriptions_on_topic_id", using: :btree
  add_index "subscriptions", ["user_id", "topic_id"], name: "index_subscriptions_on_user_id_and_topic_id", unique: true, using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "active",               default: false
    t.integer  "questions_count",      default: 0
    t.boolean  "default_subscription", default: false
    t.integer  "author_id"
  end

  add_index "topics", ["author_id"], name: "index_topics_on_author_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "activation_digest"
    t.datetime "activation_sent_at"
    t.boolean  "activated",                    default: false
    t.datetime "activated_at"
    t.string   "remember_digest"
    t.boolean  "admin",                        default: false
    t.string   "login_digest"
    t.datetime "login_sent_at"
    t.integer  "year_of_birth",      limit: 2
    t.string   "gender"
    t.string   "country_code"
    t.string   "new_email"
    t.datetime "new_email_sent_at"
    t.string   "new_email_digest"
    t.boolean  "new_email_approved",           default: false
    t.string   "time_zone"
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "answers", "interactions"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "goals", "interactions"
  add_foreign_key "goals", "users"
  add_foreign_key "improvements", "goals"
  add_foreign_key "improvements", "interactions"
  add_foreign_key "improvements", "steps"
  add_foreign_key "interactions", "users"
  add_foreign_key "questions", "topics"
  add_foreign_key "remembers", "users"
  add_foreign_key "steps", "goals"
  add_foreign_key "subscriptions", "topics"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "topics", "authors"
end
