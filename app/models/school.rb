require 'sql_utils'

class School < ActiveRecord::Base
  belongs_to :location
  has_one :theme, as: :substance
  has_many :educations
  has_many :users, through: :educations

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

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
          schools s
          inner join educations e on s.id = e.school_id
          inner join users u on e.id = u.latest_education_id
        where
          s.id = ?
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
    all_posts.count
  end

  def self.find_and_save (str)
    school = School.find_by(name: str)
    if school == nil
      school = School.new
      school.name = str
      school.save
    end
    school
  end
end
