class Company < ActiveRecord::Base
  belongs_to :location
  belongs_to :industry
  belongs_to :parent_company
  has_many :subsidiary, class_name: "Company", foreign_key: "parent_company_id"
  has_many :careers
  has_many :users, through: :careers
  has_one :theme, as: :substance

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
end
