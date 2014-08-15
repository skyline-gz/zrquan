class ConsultSubject < ActiveRecord::Base
  belongs_to :theme
  belongs_to :mentor, class_name: "User"
  belongs_to :apprentice, class_name: "User"
	has_many :consult_replies
	has_many :news_feeds, as: :feedable
	accepts_nested_attributes_for :mentor
end
