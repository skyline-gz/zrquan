class School < ActiveRecord::Base
  belongs_to :location

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}
end
