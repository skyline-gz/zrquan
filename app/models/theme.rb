require 'sql_utils'
require 'theme_sql'

class Theme < ActiveRecord::Base
  belongs_to :substance, polymorphic: true
  has_many :question_themes
  has_many :post_themes
	has_many :questions, through: :question_themes
	has_many :posts, through: :post_themes
  has_many :theme_follows
  has_many :followers, class_name: "User", through: :theme_follows, source: :user

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

  searchable do
    text :name, :description
  end

  def following_count
    theme_follows.count
  end

  def questions_num
    question_themes.count
  end

  def posts_num
    post_themes.count
  end

  def all_questions
    finished_sql = SqlUtils.escape_sql(ThemeSql::ALL_QUESTIONS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def all_posts
    finished_sql = SqlUtils.escape_sql(ThemeSql::ALL_POSTS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end
end
