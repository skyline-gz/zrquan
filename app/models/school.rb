class School < ActiveRecord::Base
  belongs_to :location
  has_one :theme, as: :substance
  has_many :educations
  has_many :users, through: :educations

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

  def posts
    theme.posts
  end

  def questions
    theme.questions
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
