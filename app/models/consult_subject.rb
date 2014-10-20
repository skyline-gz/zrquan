class ConsultSubject < ActiveRecord::Base
  belongs_to :mentor, class_name: "User"
  belongs_to :apprentice, class_name: "User"
	has_many :consult_replies
	has_many :news_feeds, as: :feedable
	has_many :activities, as: :target
	has_many :consult_themes
	accepts_nested_attributes_for :mentor

	validates :title, presence: true, on: :create
end
