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
	has_many :news_feeds, as: :feedable
	has_many :activities, as: :target
	accepts_nested_attributes_for :invitations

	validates :title, :theme_id, presence: true, on: :create

	#def answers_num
	#	answers.size
	#end

	# 返回已经排好序的所有答案（被邀导师答案置顶，其他按照赞同分数排列）
	def sorted_answers
		invited_answers = Array.new
		normal_answers = Array.new
		answers.each do |ans|
			if invited_mentors.include? ans.user
				invited_answers << ans
			else
				normal_answers << ans
			end
		end
		# 两类型答案分别按赞同分数排序，然后合并
		invited_answers.sort_by {|ia| -ia.agree_score}
		normal_answers.sort_by {|na| -na.agree_score}
		invited_answers + normal_answers
	end

	def mentor_ids
		mentor_ids = Array.new
		invitations.each do |inv|
			mentor_ids << inv.mentor_id
		end
		logger.debug(mentor_ids)
		mentor_ids
	end

end
