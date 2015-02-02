class Theme < ActiveRecord::Base
  belongs_to :substance, polymorphic: true
  has_many :question_themes
  has_many :post_thems
	has_many :questions, through: :question_themes
	has_many :posts, through: :post_themes
  has_many :theme_follows
  has_many :followers, class_name: "User", through: :theme_follows, source: :user

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

  def all_questions
    finished_sql = SqlUtils.escape_sql(
        "select
          q2.title,
          q2.anonymous_flag,
          q2.created_at,
          answer_cnt,
          answer_agree,
          follow_cnt,
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          t.name as theme_name
        from
          QUESTIONS q2 inner join
          (select
             q.id,
             count(a.id) as answer_cnt,
             sum(a.agree_score) as answer_agree,
             count(qf.follow_id) as follow_cnt
           from
           QUESTIONS q inner join QUESTION_THEMES qt on q.id = qt.question_id
           inner join ANSWERS a on q.id = a.question_id
           inner join QUESTION_FOLLOWS qf on q.id = qf.question_id
           where
           qt.theme_id = ?
           group by q.id
          ) t1 on q2.id = t1.id
          inner join USERS u on q2.user_id = u.id
          inner join THEMES t on t.id = ?
        order by q2.hot
        limit 20", id, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def all_posts
    finished_sql = SqlUtils.escape_sql(
        "select
          p2.content,
          p2.anonymous_flag,
          p2.created_at,
          p2.agree_score,
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          t.name as theme_name
        from
          POSTS p2 inner join
          (select
             p.id,
             count(pc.id) as comment_cnt,
             sum(pc.agree_score) as comment_agree
           from
           POSTS p inner join POST_THEMES pt on p.id = pt.post_id
           inner join POST_COMMENTS pc on p.id = pc.post_id
           where
           pt.theme_id = ?
           group by p.id
          ) t1 on p2.id = t1.id
          inner join USERS u on p2.user_id = u.id
          inner join THEMES t on t.id = ?
        order by p2.hot
        limit 20", id, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end
end
