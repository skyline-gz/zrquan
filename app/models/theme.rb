class Theme < ActiveRecord::Base
  belongs_to :substance, polymorphic: true

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}
end
