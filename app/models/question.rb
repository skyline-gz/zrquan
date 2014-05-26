class Question < ActiveRecord::Base
  belongs_to :theme
  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :answers
	has_many :invite_users, class_name: "User", through: :invitations
	has_many :bookmark_users, class_name: "User", through: :bookmarks
end
