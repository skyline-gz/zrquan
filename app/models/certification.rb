class Certification < ActiveRecord::Base
  has_many :themes, as: :substance

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}
end
