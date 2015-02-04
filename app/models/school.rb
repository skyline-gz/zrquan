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
    users.order("reputation desc")
  end

  def questions_num
    theme.questions_num
  end

  def posts_num
    theme.questions_num
  end

  def users_num
    users.count
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
