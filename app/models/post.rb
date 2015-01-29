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
    result = ActiveRecord::Base.connection.select_all(
        ["select min(recent_days) as recent_days
          from post_stats ps
          where ps.user_id = ? and ps.following_act_count >= ?", current_user.id, 500]
    )
    result[0]["recent_days"]
  end

  def hottest_comment
    hot_comments[0]
  end

  def hot_comments
    ActiveRecord::Base.connection.select_all(
        ["select pc.content, pc.agree_score, pc.created_at, u.name, u.avatar
          from post_comments pc inner join users u on (pc.user_id = u.id)
          where pc.post_id = ? order by pc.actual_score DESC limit 10", id])
  end

  def all_comments
    ActiveRecord::Base.connection.select_all(
        ["select pc.content, pc.agree_score, pc.created_at, u.name, u.avatar
          from post_comments pc inner join users u on (pc.user_id = u.id)
          where pc.post_id = ? order by pc.created_at DESC", id])
  end
end
