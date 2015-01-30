class Question < ActiveRecord::Base
	after_create :randomize_token_id

	searchable do
		text :title, :content
	end

  belongs_to :industry
  belongs_to :category
  belongs_to :user
	has_many :answers
	has_many :question_follows
	has_many :followers, class_name: "User", through: :question_follows, source: :user
	has_many :bookmarks, as: :bookmarkable
	has_many :comments, as: :commentable
	has_many :news_feeds, as: :feedable
	has_many :activities, as: :target
	has_many :question_themes
	has_many :themes, through: :question_themes
  accepts_nested_attributes_for :question_themes

	validates :title, presence: true, on: :create
  validates :title, length: {in: 8..50}
  validates :content, length: {maximum: 10000}

	#def answers_num
	#	answers.size
	#end

  def self.sufficient_days
    result = ActiveRecord::Base.connection.select_all(
        ["select min(recent_days) as recent_days
          from question_stats qs
          where qs.user_id = ? and qs.following_act_count >= ?", current_user.id, 500]
    )
    result[0]["recent_days"]
  end

  def detail
    ActiveRecord::Base.connection.select_all(
        ["select
            q.title,
            q.content,
            q.created_at,
            u.name,
            u.avatar,
            u.latest_company_name,
            u.latest_position,
            u.latest_school_name,
            u.latest_major
          from questions q inner join users u on (q.user_id = u.id)
          where q.id = ?", id])
  end

	# 返回已经排好序的所有答案（被邀导师答案置顶，其他按照赞同分数排列）
	def sorted_answers
    ActiveRecord::Base.connection.select_all(
        ["select
            a.content,
            a.agree_score,
            a.created_at,
            u.name,
            u.avatar,
            u.latest_company_name,
            u.latest_position,
            u.latest_school_name,
            u.latest_major
          from ANSWERS a inner join users u on (a.user_id = u.id)
          where a.question_id = ? order by a.actual_score DESC limit 10", id])
	end

	# 返回最佳答案
	def recommend_answer
    sorted_answers[0]
  end

  def sorted_comments
    ActiveRecord::Base.connection.select_all(
        ["select
            c.content,
            c.created_at,
            u.name,
            u.avatar,
            u.latest_company_name,
            u.latest_position,
            u.latest_school_name,
            u.latest_major
          from comments c inner join users u on (c.user_id = u.id)
          where c.commentable_id = ? and c.commentable_type = 'Question'
          order by c.created_at DESC", id])
  end

  def theme_ids
    theme_ids = Array.new
    question_themes.each do |qt|
      theme_ids << qt.theme_id
    end
    theme_ids
  end

	private
	def randomize_token_id
		self.token_id = 102139 + self.id * 29 + SecureRandom.random_number(29)
		self.save
	end
end
