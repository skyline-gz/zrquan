class ConsultantSubject < ActiveRecord::Base
  belongs_to :theme
  belongs_to :mentor, class_name: "User"
  belongs_to :apprentice, class_name: "User"
	has_many :consultant_replies
end
