class ExperienceArticle < ActiveRecord::Base
  belongs_to :theme
  belongs_to :industry
  belongs_to :category
  belongs_to :user
end
