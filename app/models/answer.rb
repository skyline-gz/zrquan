class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
	has_many :comments, as: :commentable
	has_many :activities, as: :target
	has_many :agreements, as: :agreeable

	validates :content, presence: true
end
