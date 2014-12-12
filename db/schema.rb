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

ActiveRecord::Schema.define(version: 20141212072953) do

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
    t.datetime "edited_at"
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

  create_table "careers", force: true do |t|
    t.integer  "user_id"
    t.integer  "industry_id"
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
  add_index "careers", ["industry_id"], name: "index_careers_on_industry_id", using: :btree
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

  create_table "company_salaries", force: true do |t|
    t.integer  "company_id"
    t.string   "position"
    t.integer  "salary_sum"
    t.integer  "samples"
    t.integer  "salary_avg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_salaries", ["company_id"], name: "index_company_salaries_on_company_id", using: :btree

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
    t.integer  "mentor_id"
    t.integer  "apprentice_id"
    t.integer  "stat_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consult_subjects", ["apprentice_id"], name: "index_consult_subjects_on_apprentice_id", using: :btree
  add_index "consult_subjects", ["mentor_id"], name: "index_consult_subjects_on_mentor_id", using: :btree

  create_table "consult_themes", force: true do |t|
    t.integer  "consult_subject_id"
    t.integer  "theme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consult_themes", ["consult_subject_id"], name: "index_consult_themes_on_consult_subject_id", using: :btree
  add_index "consult_themes", ["theme_id"], name: "index_consult_themes_on_theme_id", using: :btree

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

  create_table "food_styles", force: true do |t|
    t.string   "content"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "food_styles", ["location_id"], name: "index_food_styles_on_location_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "content"
    t.integer  "wiki_id"
    t.string   "wiki_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["wiki_id", "wiki_type"], name: "index_images_on_wiki_id_and_wiki_type", using: :btree

  create_table "impressions", force: true do |t|
    t.string   "content"
    t.integer  "wiki_id"
    t.string   "wiki_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["wiki_id", "wiki_type"], name: "index_impressions_on_wiki_id_and_wiki_type", using: :btree

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

  create_table "invitations", force: true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["question_id"], name: "index_invitations_on_question_id", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

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

  create_table "other_wikis", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "other_wikis", ["name"], name: "index_other_wikis_on_name", unique: true, using: :btree

  create_table "personal_salaries", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "position"
    t.integer  "salary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "personal_salaries", ["company_id"], name: "index_personal_salaries_on_company_id", using: :btree
  add_index "personal_salaries", ["user_id"], name: "index_personal_salaries_on_user_id", using: :btree

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
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "hot_abs"
    t.integer  "latest_answer_id"
    t.integer  "latest_qa_time",   limit: 8
    t.datetime "edited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["latest_answer_id"], name: "index_questions_on_latest_answer_id", using: :btree
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

  create_table "user_theme_stats", force: true do |t|
    t.integer  "user_id"
    t.integer  "theme_id"
    t.integer  "question_count"
    t.integer  "answer_count"
    t.integer  "total_agree_score"
    t.integer  "apply_consult_count"
    t.string   "accept_consult_count"
    t.integer  "fin_mentor_consult_count"
    t.integer  "mentor_score_sum"
    t.integer  "score_consult_count"
    t.integer  "mentor_score_avg"
    t.integer  "reputation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_theme_stats", ["theme_id"], name: "index_user_theme_stats_on_theme_id", using: :btree
  add_index "user_theme_stats", ["user_id"], name: "index_user_theme_stats_on_user_id", using: :btree

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
    t.string   "last_name"
    t.string   "first_name"
    t.integer  "gender"
    t.integer  "location_id"
    t.integer  "latest_company_id"
    t.string   "latest_position"
    t.integer  "latest_school_id"
    t.string   "latest_major"
    t.string   "description"
    t.string   "mobile"
    t.integer  "total_agree_score"
    t.integer  "reputation"
    t.boolean  "verified_flag"
    t.string   "avatar"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["latest_company_id"], name: "index_users_on_latest_company_id", using: :btree
  add_index "users", ["latest_school_id"], name: "index_users_on_latest_school_id", using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "welfares", force: true do |t|
    t.string   "content"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "welfares", ["company_id"], name: "index_welfares_on_company_id", using: :btree

end
