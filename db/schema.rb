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

ActiveRecord::Schema.define(version: 20140508082021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.text     "content"
    t.integer  "agree_score"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "comment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "consultant_replies", force: true do |t|
    t.integer  "consultant_subject_id"
    t.integer  "reply_seq"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consultant_replies", ["consultant_subject_id"], name: "index_consultant_replies_on_consultant_subject_id", using: :btree
  add_index "consultant_replies", ["user_id"], name: "index_consultant_replies_on_user_id", using: :btree

  create_table "consultant_subjects", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "theme_id"
    t.integer  "mentor_id"
    t.integer  "apprentice_id"
    t.integer  "mentor_stat_flag"
    t.integer  "user_stat_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consultant_subjects", ["apprentice_id"], name: "index_consultant_subjects_on_apprentice_id", using: :btree
  add_index "consultant_subjects", ["mentor_id"], name: "index_consultant_subjects_on_mentor_id", using: :btree
  add_index "consultant_subjects", ["theme_id"], name: "index_consultant_subjects_on_theme_id", using: :btree

  create_table "experience_articles", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "agree_score"
    t.integer  "theme_id"
    t.integer  "industry_id"
    t.integer  "category_id"
    t.boolean  "mark_flag"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "experience_articles", ["category_id"], name: "index_experience_articles_on_category_id", using: :btree
  add_index "experience_articles", ["industry_id"], name: "index_experience_articles_on_industry_id", using: :btree
  add_index "experience_articles", ["theme_id"], name: "index_experience_articles_on_theme_id", using: :btree
  add_index "experience_articles", ["user_id"], name: "index_experience_articles_on_user_id", using: :btree

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "title",       null: false
    t.text     "content"
    t.integer  "theme_id",    null: false
    t.integer  "industry_id"
    t.integer  "category_id"
    t.integer  "answer_num"
    t.boolean  "mark_flag"
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["industry_id"], name: "index_questions_on_industry_id", using: :btree
  add_index "questions", ["theme_id"], name: "index_questions_on_theme_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "themes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt"
    t.string   "last_name",                           null: false
    t.string   "first_name",                          null: false
    t.integer  "gender"
    t.integer  "province_id"
    t.integer  "city_id"
    t.string   "school"
    t.string   "major"
    t.string   "industry"
    t.string   "company"
    t.string   "position"
    t.string   "signature"
    t.integer  "following",              default: 0,  null: false
    t.integer  "follower",               default: 0,  null: false
    t.text     "description"
    t.boolean  "mentor_flag"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["province_id"], name: "index_users_on_province_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
