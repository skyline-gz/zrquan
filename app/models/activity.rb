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

	def answer_article?
		activity_type == 4
	end

	def agree_answer?
		activity_type == 5
	end

	def agree_article?
		activity_type == 6
	end

	def accept_consult?
		activity_type == 7
	end

	def consult?
		activity_type == 8
	end
end
