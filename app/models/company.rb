class Company < ActiveRecord::Base
  belongs_to :location
  belongs_to :industry
  belongs_to :parent_company
  has_many :subsidiary, class_name: "Company", foreign_key: "parent_company_id"
  has_many :company_salaries

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}
end
