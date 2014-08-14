class Question < ActiveRecord::Base
	searchable do
		text :title, :content
	end

  belongs_to :theme
  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :answers
	has_many :invitations
	has_many :invited_mentors, class_name: "User", through: :invitations, source: :mentor
	has_many :bookmarks, as: :bookmarkable
	accepts_nested_attributes_for :invitations

	#def answers_num
	#	answers.size
	#end

	def mentor_ids
		mentor_ids = Array.new
		invitations.each do |inv|
			mentor_ids << inv.mentor_id
		end
		logger.debug(mentor_ids)
		mentor_ids
	end

end
