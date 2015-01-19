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

ActiveRecord::Schema.define(version: 20150118093208) do

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

  create_table "answer_drafts", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_drafts", ["question_id"], name: "index_answer_drafts_on_question_id", using: :btree
  add_index "answer_drafts", ["user_id"], name: "index_answer_drafts_on_user_id", using: :btree

  create_table "answers", force: true do |t|
    t.integer  "token_id"
    t.text     "content"
    t.integer  "agree_score",    default: 0
    t.integer  "oppose_score",   default: 0
    t.boolean  "anonymous_flag", default: false
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "edited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["token_id"], name: "index_answers_on_token_id", unique: true, using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id"
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookmarks", ["bookmarkable_id", "bookmarkable_type"], name: "index_bookmarks_on_bookmarkable_id_and_bookmarkable_type", using: :btree
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id", using: :btree

  create_table "careers", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "position"
    t.string   "entry_year"
    t.string   "entry_month"
    t.string   "leave_year"
    t.string   "leave_month"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "careers", ["company_id"], name: "index_careers_on_company_id", using: :btree
  add_index "careers", ["user_id"], name: "index_careers_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "certifications", force: true do |t|
    t.string   "name"
    t.integer  "study_time_sum"
    t.integer  "study_time_samples"
    t.integer  "study_time_avg"
    t.integer  "study_cost_sum"
    t.integer  "study_cost_samples"
    t.integer  "study_cost_avg"
    t.text     "regist_rule"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "certifications", ["name"], name: "index_certifications_on_name", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "anonymous_flag",     default: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "replied_comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["replied_comment_id"], name: "index_comments_on_replied_comment_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.integer  "industry_id"
    t.integer  "parent_company_id"
    t.string   "address"
    t.string   "site"
    t.string   "contact"
    t.string   "legal_person"
    t.integer  "capital_state"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["industry_id"], name: "index_companies_on_industry_id", using: :btree
  add_index "companies", ["location_id"], name: "index_companies_on_location_id", using: :btree
  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree
  add_index "companies", ["parent_company_id"], name: "index_companies_on_parent_company_id", using: :btree

  create_table "educations", force: true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "major"
    t.string   "graduate_year"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "educations", ["school_id"], name: "index_educations_on_school_id", using: :btree
  add_index "educations", ["user_id"], name: "index_educations_on_user_id", using: :btree

  create_table "industries", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_industry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "industries", ["parent_industry_id"], name: "index_industries_on_parent_industry_id", using: :btree

  create_table "industry_job_categories", force: true do |t|
    t.integer  "industry_id"
    t.integer  "job_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "industry_job_categories", ["industry_id"], name: "index_industry_job_categories_on_industry_id", using: :btree
  add_index "industry_job_categories", ["job_category_id"], name: "index_industry_job_categories_on_job_category_id", using: :btree

  create_table "job_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.text     "expense"
    t.text     "strong_industry"
    t.text     "entry_policy"
    t.text     "support_policy"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["region_id"], name: "index_locations_on_region_id", using: :btree

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

  create_table "oppositions", force: true do |t|
    t.integer  "user_id"
    t.integer  "opposable_id"
    t.string   "opposable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oppositions", ["opposable_id", "opposable_type"], name: "index_oppositions_on_opposable_id_and_opposable_type", using: :btree
  add_index "oppositions", ["user_id"], name: "index_oppositions_on_user_id", using: :btree

  create_table "other_wikis", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "other_wikis", ["name"], name: "index_other_wikis_on_name", unique: true, using: :btree

  create_table "post_comments", force: true do |t|
    t.text     "content"
    t.integer  "agree_score"
    t.integer  "oppose_score"
    t.boolean  "anonymous_flag"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "replied_comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_comments", ["post_id"], name: "index_post_comments_on_post_id", using: :btree
  add_index "post_comments", ["replied_comment_id"], name: "index_post_comments_on_replied_comment_id", using: :btree
  add_index "post_comments", ["user_id"], name: "index_post_comments_on_user_id", using: :btree

  create_table "post_themes", force: true do |t|
    t.integer  "post_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_themes", ["post_id"], name: "index_post_themes_on_post_id", using: :btree
  add_index "post_themes", ["theme_id"], name: "index_post_themes_on_theme_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "token_id"
    t.text     "content"
    t.integer  "weight"
    t.float    "epoch_time",     limit: 53
    t.float    "hot",            limit: 53
    t.integer  "agree_score",               default: 0
    t.integer  "oppose_score",              default: 0
    t.boolean  "anonymous_flag",            default: false
    t.integer  "user_id"
    t.datetime "edited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["hot"], name: "index_posts_on_hot", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

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

  create_table "question_follows", force: true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_follows", ["question_id"], name: "index_question_follows_on_question_id", using: :btree
  add_index "question_follows", ["user_id"], name: "index_question_follows_on_user_id", using: :btree

  create_table "question_themes", force: true do |t|
    t.integer  "question_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_themes", ["question_id"], name: "index_question_themes_on_question_id", using: :btree
  add_index "question_themes", ["theme_id"], name: "index_question_themes_on_theme_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "token_id"
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "anonymous_flag",              default: false
    t.integer  "weight"
    t.float    "epoch_time",       limit: 53
    t.float    "hot",              limit: 53
    t.integer  "latest_answer_id"
    t.integer  "latest_qa_time",   limit: 8
    t.datetime "edited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["hot"], name: "index_questions_on_hot", using: :btree
  add_index "questions", ["latest_answer_id"], name: "index_questions_on_latest_answer_id", using: :btree
  add_index "questions", ["token_id"], name: "index_questions_on_token_id", unique: true, using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "recommend_users", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommend_users", ["user_id"], name: "index_recommend_users_on_user_id", using: :btree

  create_table "regions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.integer  "following_user_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  add_index "relationships", ["following_user_id"], name: "index_relationships_on_following_user_id", using: :btree

  create_table "schools", force: true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.string   "address"
    t.string   "site"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["location_id"], name: "index_schools_on_location_id", using: :btree
  add_index "schools", ["name"], name: "index_schools_on_name", unique: true, using: :btree

  create_table "skills", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "theme_follows", force: true do |t|
    t.integer  "theme_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "theme_follows", ["theme_id"], name: "index_theme_follows_on_theme_id", using: :btree
  add_index "theme_follows", ["user_id"], name: "index_theme_follows_on_user_id", using: :btree

  create_table "themes", force: true do |t|
    t.string   "name"
    t.integer  "substance_id"
    t.string   "substance_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "themes", ["name"], name: "index_themes_on_name", unique: true, using: :btree
  add_index "themes", ["substance_id", "substance_type"], name: "index_themes_on_substance_id_and_substance_type", using: :btree

  create_table "user_attachments", force: true do |t|
    t.integer  "user_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "url"
    t.string   "original_name"
    t.string   "content_type"
    t.string   "attach_type"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_attachments", ["attachable_id", "attachable_type"], name: "index_user_attachments_on_attachable_id_and_attachable_type", using: :btree
  add_index "user_attachments", ["user_id"], name: "index_user_attachments_on_user_id", using: :btree

  create_table "user_msg_settings", force: true do |t|
    t.boolean  "followed_flag",  default: true
    t.boolean  "agreed_flag",    default: true
    t.boolean  "commented_flag", default: true
    t.boolean  "answer_flag",    default: true
    t.boolean  "pm_flag",        default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_msg_settings", ["user_id"], name: "index_user_msg_settings_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "mobile",                    limit: 20, default: "", null: false
    t.string   "encrypted_password",                   default: "", null: false
    t.integer  "sign_in_count",                        default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "current_sign_in_verify_at"
    t.string   "name"
    t.integer  "gender"
    t.integer  "location_id"
    t.integer  "industry_id"
    t.integer  "latest_career_id"
    t.integer  "latest_education_id"
    t.string   "description"
    t.boolean  "verified_flag"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["industry_id"], name: "index_users_on_industry_id", using: :btree
  add_index "users", ["latest_career_id"], name: "index_users_on_latest_career_id", using: :btree
  add_index "users", ["latest_education_id"], name: "index_users_on_latest_education_id", using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree

end
