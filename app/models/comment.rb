class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :replied_comment
	has_many :activities, as: :target

	validates :content, presence: true, on: :create
	validates :content, length: {in: 1..1000}
end
