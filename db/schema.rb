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

ActiveRecord::Schema.define(version: 20141030045217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "activity_type"
    t.integer  "publish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["target_id", "target_type"], name: "index_activities_on_target_id_and_target_type", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "agreements", force: true do |t|
    t.integer  "user_id"
    t.integer  "agreeable_id"
    t.string   "agreeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agreements", ["agreeable_id", "agreeable_type"], name: "index_agreements_on_agreeable_id_and_agreeable_type", using: :btree
  add_index "agreements", ["user_id"], name: "index_agreements_on_user_id", using: :btree

  create_table "answers", force: true do |t|
    t.text     "content"
    t.integer  "agree_score", default: 0
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "article_themes", force: true do |t|
    t.integer  "article_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_themes", ["article_id"], name: "index_article_themes_on_article_id", using: :btree
  add_index "article_themes", ["theme_id"], name: "index_article_themes_on_theme_id", using: :btree

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "draft_flag",  default: false
    t.integer  "agree_score", default: 0
    t.integer  "industry_id"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
  add_index "articles", ["industry_id"], name: "index_articles_on_industry_id", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id"
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks", ["bookmarkable_id", "bookmarkable_type"], name: "index_bookmarks_on_bookmarkable_id_and_bookmarkable_type", using: :btree
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
    t.integer  "user_id"
    t.integer  "apprentice_id"
    t.integer  "stat_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consult_subjects", ["apprentice_id"], name: "index_consult_subjects_on_apprentice_id", using: :btree
  add_index "consult_subjects", ["user_id"], name: "index_consult_subjects_on_user_id", using: :btree

  create_table "consult_themes", force: true do |t|
    t.integer  "consult_subject_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consult_themes", ["consult_subject_id"], name: "index_consult_themes_on_consult_subject_id", using: :btree
  add_index "consult_themes", ["theme_id"], name: "index_consult_themes_on_theme_id", using: :btree

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["question_id"], name: "index_invitations_on_question_id", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "mentor_themes", force: true do |t|
    t.integer  "user_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mentor_themes", ["theme_id"], name: "index_mentor_themes_on_theme_id", using: :btree
  add_index "mentor_themes", ["user_id"], name: "index_mentor_themes_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "msg_type"
    t.integer  "user_id"
    t.integer  "extra_info1_id"
    t.string   "extra_info1_type"
    t.integer  "extra_info2_id"
    t.string   "extra_info2_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read_flag",        default: false
  end

  add_index "messages", ["extra_info1_id", "extra_info1_type"], name: "index_messages_on_extra_info1_id_and_extra_info1_type", using: :btree
  add_index "messages", ["extra_info2_id", "extra_info2_type"], name: "index_messages_on_extra_info2_id_and_extra_info2_type", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "news_feeds", force: true do |t|
    t.integer  "feedable_id"
    t.string   "feedable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_feeds", ["feedable_id", "feedable_type"], name: "index_news_feeds_on_feedable_id_and_feedable_type", using: :btree

  create_table "private_messages", force: true do |t|
    t.text     "content"
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.integer  "send_class"
    t.boolean  "read_flag",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "private_messages", ["user1_id"], name: "index_private_messages_on_user1_id", using: :btree
  add_index "private_messages", ["user2_id"], name: "index_private_messages_on_user2_id", using: :btree

  create_table "question_themes", force: true do |t|
    t.integer  "question_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_themes", ["question_id"], name: "index_question_themes_on_question_id", using: :btree
  add_index "question_themes", ["theme_id"], name: "index_question_themes_on_theme_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "industry_id"
    t.integer  "category_id"
    t.integer  "answer_num",  default: 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["category_id"], name: "index_questions_on_category_id", using: :btree
  add_index "questions", ["industry_id"], name: "index_questions_on_industry_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "recommend_users", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommend_users", ["user_id"], name: "index_recommend_users_on_user_id", using: :btree

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
    t.boolean  "followed_flag",  default: true
    t.boolean  "aggred_flag",    default: true
    t.boolean  "commented_flag", default: true
    t.boolean  "answer_flag",    default: true
    t.boolean  "pm_flag",        default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_settings", ["user_id"], name: "index_user_settings_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
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
    t.text     "description"
    t.boolean  "verified_flag",          default: false
    t.string   "avatar"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["province_id"], name: "index_users_on_province_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
