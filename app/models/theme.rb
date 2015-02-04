require 'sql_utils'

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

  def questions_num
    question_themes.count
  end

  def posts_num
    post_themes.count
  end

  def all_questions
    finished_sql = SqlUtils.escape_sql(
        "select
          q.title,
          q.anonymous_flag,
          q.created_at,
          q.answer_count,
          q.answer_agree,
          q.follow_count,
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          t.name as theme_name
        from
          QUESTIONS q inner join QUESTION_THEMES qt on q.id = qt.question_id
          inner join ANSWERS a on q.id = a.question_id
          inner join USERS u on q.user_id = u.id
          inner join THEMES t on t.id = qt.theme_id
        where
          qt.theme_id = ?
        order by q.created_at
        limit 20", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def all_posts
    finished_sql = SqlUtils.escape_sql(
        "select
          p.content,
          p.anonymous_flag,
          p.created_at,
          p.agree_score,
          p.comment_count,
          p.comment_agree,
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          t.name as theme_name
        from
          POSTS p inner join POST_THEMES pt on p.id = pt.post_id
          inner join USERS u on p.user_id = u.id
          inner join THEMES t on t.id = pt.theme_id
        where
          pt.theme_id = ?
        order by p.created_at
        limit 20", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end
end
