require 'sql_utils'

class Location < ActiveRecord::Base
  belongs_to :region
  has_one :theme, as: :substance
  has_many :users

  def all_posts
    theme.all_posts
  end

  def all_questions
    theme.all_questions
  end

  def all_users
    finished_sql = SqlUtils.escape_sql(
        "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          users u
        where
          u.location_id = ?
        order by u.created_at desc", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def questions_num
    theme.questions_num
  end

  def posts_num
    theme.questions_num
  end

  def users_num
    all_users.count
  end
end
