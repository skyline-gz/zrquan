require 'sql_utils'

class Region < ActiveRecord::Base
  has_one :theme, as: :substance

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
          inner join locations l on u.location_id = l.id
        where
          l.region_id = ?
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
