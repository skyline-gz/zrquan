class Certification < ActiveRecord::Base

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}
end
