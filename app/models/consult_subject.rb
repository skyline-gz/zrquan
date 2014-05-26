class ConsultSubject < ActiveRecord::Base
  belongs_to :theme
  belongs_to :mentor
  belongs_to :apprentice
	has_many :consult_replies
end
