require 'sql_utils'
require 'answer_sql'

class Answer < ActiveRecord::Base
	after_create :randomize_token_id

  belongs_to :user
  belongs_to :question
	has_many :comments, as: :commentable
	has_many :activities, as: :target
	has_many :agreements, as: :agreeable
	has_many :oppositions, as: :opposable

	validates :content, presence: true, on: :create
	validates :content, length: {in: 8..10000}

  def detail
    finished_sql = SqlUtils.escape_sql(AnswerSql::DETAIL, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def sorted_comments
    finished_sql = SqlUtils.escape_sql(AnswerSql::SORTED_COMMENTS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

	private
	def randomize_token_id
		self.token_id = 101747 + self.id * 23 + SecureRandom.random_number(23)
		self.save
	end
end
