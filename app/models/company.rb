class Company < ActiveRecord::Base
  belongs_to :city
  belongs_to :industry
  belongs_to :parent_company
  has_many :subsidiary, class_name: "Company", foreign_key: "parent_company_id"
  has_many :company_salaries
end
