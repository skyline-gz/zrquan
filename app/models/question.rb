class Question < ActiveRecord::Base
	searchable do
		text :title, :content
	end

  belongs_to :theme
  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :answers
	has_many :invite_users, class_name: "User", through: :invitations
	has_many :bookmark_users, class_name: "User", through: :bookmarks
end
