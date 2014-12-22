class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :theme

	def pdate_to_s
		Date.parse(publish_date.to_s)
	end

	def ask_question?
		activity_type == 1
	end

	def answer_question?
		activity_type == 2
	end

	def comment_answer?
		activity_type == 3
	end

	def comment_question?
		activity_type == 4
	end

end
