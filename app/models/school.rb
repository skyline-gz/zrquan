class School < ActiveRecord::Base
  belongs_to :location
  has_many :themes, as: :substance

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

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
