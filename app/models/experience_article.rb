class ExperienceArticle < ActiveRecord::Base
  belongs_to :theme
  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :comments, as: :commentable
end
