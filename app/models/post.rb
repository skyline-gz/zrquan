class Post < ActiveRecord::Base
  belongs_to :user
  has_many :post_comments
  has_many :agreements, as: :agreeable
  has_many :oppositions, as: :opposable
  has_many :post_themes
  has_many :themes, through: :post_themes
  has_many :bookmarks, as: :bookmarkable

  validates :content, presence: true, on: :create
  validates :content, length: {in: 1..140}

  def self.sufficient_days
    finished_sql = SqlUtils.escape_sql(
        "select min(recent_days) as recent_days
        from post_stats ps
        where ps.user_id = ? and ps.following_act_count >= ?", current_user.id, 500
    )
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["recent_days"]
  end

  def detail
    finished_sql = SqlUtils.escape_sql(
        "select
          p.content,
          p.created_at,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from posts p inner join users u on (p.user_id = u.id)
        where p.id = ?", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def hottest_comment
    hot_comments[0]
  end

  def hot_comments
    finished_sql = SqlUtils.escape_sql(
        "select
          pc.id,
          pc.content,
          pc.agree_score,
          pc.created_at,
          u.name as comment_user_name,
          u.avatar,
          rpu.name as replied_user_name
        from
          post_comments pc
          inner join users u on (pc.user_id = u.id)
          left join post_comments rp on (pc.replied_comment_id = rp.id)
          left join users rpu on (rp.user_id = rpu.id)
        where pc.post_id = ?
        order by pc.actual_score DESC
        limit 10", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def all_comments
    finished_sql = SqlUtils.escape_sql(
        "select
          pc.id,
          pc.content,
          pc.agree_score,
          pc.created_at,
          u.name as comment_user_name,
          u.avatar,
          rpu.name as replied_user_name
        from
          post_comments pc
          inner join users u on (pc.user_id = u.id)
          left join post_comments rp on (pc.replied_comment_id = rp.id)
          left join users rpu on (rp.user_id = rpu.id)
        where pc.post_id = ?
        order by pc.created_at DESC", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end
end
