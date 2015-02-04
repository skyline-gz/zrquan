require 'sql_utils'
require 'theme_sql'

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
    finished_sql = SqlUtils.escape_sql(ThemeSql::LOCATION_USERS, id)
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
