class Theme < ActiveRecord::Base
  belongs_to :substance, polymorphic: true
  has_many :question_themes
  has_many :post_thems
	has_many :questions, through: :question_themes
	has_many :posts, through: :post_thems

  validates :name, presence: true, on: :create
  validates :name, length: {in: 1..20}
end
