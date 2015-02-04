require 'sql_utils'
require 'post_sql'

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
    finished_sql = SqlUtils.escape_sql(PostSql::SUFFICIENT_DAYS, current_user.id, 500)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["recent_days"]
  end

  def detail
    finished_sql = SqlUtils.escape_sql(PostSql::DETAIL, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def hottest_comment
    hot_comments[0]
  end

  def hot_comments
    finished_sql = SqlUtils.escape_sql(PostSql::HOT_COMMENTS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def all_comments
    finished_sql = SqlUtils.escape_sql(PostSql::ALL_COMMENTS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end
end
