require 'sql_utils'
require 'question_sql'

class Question < ActiveRecord::Base
	after_create :randomize_token_id

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

  searchable do
    text :title, :content
  end

	#def answers_num
	#	answers.size
	#end

  def self.sufficient_days
    finished_sql = SqlUtils.escape_sql(QuestionSql::SUFFICIENT_DAYS, current_user.id, 500)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["recent_days"]
  end

  def detail
    finished_sql = SqlUtils.escape_sql(QuestionSql::DETAIL, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

	# 返回已经排好序的所有答案（被邀导师答案置顶，其他按照赞同分数排列）
	def sorted_answers
    finished_sql = SqlUtils.escape_sql(QuestionSql::SORTED_ANSWERS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
	end

	# 返回最佳答案
	def recommend_answer
    sorted_answers[0]
  end

  def sorted_comments
    finished_sql = SqlUtils.escape_sql(QuestionSql::SORTED_COMMENTS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
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
