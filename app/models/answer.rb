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
    finished_sql = SqlUtils.escape_sql(
        "select
          a.content,
          a.created_at,
          q.title as question_title
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from
          answers a inner join users u on (a.user_id = u.id)
          inner join questions q on (a.question_id = q.id)
        where a.id = ?", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def sorted_comments
    finished_sql = SqlUtils.escape_sql(
        "select
          c.content,
          c.created_at,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from comments c inner join users u on (c.user_id = u.id)
        where c.commentable_id = ? and c.commentable_type = 'Answer'
        order by c.created_at DESC", id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

	private
	def randomize_token_id
		self.token_id = 101747 + self.id * 23 + SecureRandom.random_number(23)
		self.save
	end
end
