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

  def hot_comments
    PostComment.find_by_sql(
        ["select pc.*, (pc.agree_score - pc.oppose_score) as actual_score
         from POST_COMMENTS pc
				 where pc.post_id = ? order by actual_score DESC", id])
  end

  def all_comments
    post_comments.order('created_at desc')
  end
end
