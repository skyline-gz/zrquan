class Company < ActiveRecord::Base
  belongs_to :location
  belongs_to :industry
  belongs_to :parent_company
  has_many :subsidiary, class_name: "Company", foreign_key: "parent_company_id"
  has_many :company_salaries
  has_many :themes, as: :substance

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}

  def self.find_and_save (str)
    company = Company.find_by(name: str)
    if company == nil
      company = Company.new
      company.name = str
      company.save
    end
    company
  end
end
