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

ActiveRecord::Schema.define(version: 20140609075243) do

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

  create_table "articles", force: true do |t|
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
    t.boolean  "draft_flag"
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
  add_index "articles", ["industry_id"], name: "index_articles_on_industry_id", using: :btree
  add_index "articles", ["theme_id"], name: "index_articles_on_theme_id", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "bookmarks", force: true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks", ["question_id"], name: "index_bookmarks_on_question_id", using: :btree
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "consult_replies", force: true do |t|
    t.integer  "consult_subject_id"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consult_replies", ["consult_subject_id"], name: "index_consult_replies_on_consult_subject_id", using: :btree
  add_index "consult_replies", ["user_id"], name: "index_consult_replies_on_user_id", using: :btree

  create_table "consult_subjects", force: true do |t|
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

  add_index "consult_subjects", ["apprentice_id"], name: "index_consult_subjects_on_apprentice_id", using: :btree
  add_index "consult_subjects", ["mentor_id"], name: "index_consult_subjects_on_mentor_id", using: :btree
  add_index "consult_subjects", ["theme_id"], name: "index_consult_subjects_on_theme_id", using: :btree

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "question_id"
    t.integer  "mentor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["mentor_id"], name: "index_invitations_on_mentor_id", using: :btree
  add_index "invitations", ["question_id"], name: "index_invitations_on_question_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "msg_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "private_messages", force: true do |t|
    t.text     "content"
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.integer  "send_class"
    t.boolean  "read_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "private_messages", ["user1_id"], name: "index_private_messages_on_user1_id", using: :btree
  add_index "private_messages", ["user2_id"], name: "index_private_messages_on_user2_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "theme_id"
    t.integer  "industry_id"
    t.integer  "category_id"
    t.integer  "answer_num"
    t.boolean  "mark_flag"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["industry_id"], name: "index_questions_on_industry_id", using: :btree
  add_index "questions", ["theme_id"], name: "index_questions_on_theme_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "following_user_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  add_index "relationships", ["following_user_id"], name: "index_relationships_on_following_user_id", using: :btree

  create_table "themes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_settings", force: true do |t|
    t.boolean  "followed_flag"
    t.boolean  "aggred_flag"
    t.boolean  "commented_flag"
    t.boolean  "answer_flag"
    t.boolean  "pm_flag"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_settings", ["user_id"], name: "index_user_settings_on_user_id", using: :btree

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt"
    t.string   "last_name"
    t.string   "first_name"
    t.integer  "gender"
    t.integer  "province_id"
    t.integer  "city_id"
    t.string   "school"
    t.string   "major"
    t.string   "industry"
    t.string   "company"
    t.string   "position"
    t.string   "signature"
    t.integer  "following",              default: 0
    t.integer  "follower",               default: 0
    t.text     "description"
    t.boolean  "mentor_flag"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["province_id"], name: "index_users_on_province_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
