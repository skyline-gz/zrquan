class Answer < ActiveRecord::Base
	before_create :randomize_token_id

  belongs_to :user
  belongs_to :question
	has_many :comments, as: :commentable
	has_many :activities, as: :target
	has_many :agreements, as: :agreeable

	validates :content, presence: true, on: :create
	validates :content, length: {in: 8..10000}

	private
	def randomize_token_id
		begin
			self.token_id = Random.rand(10_000_000 ... 10_000_000_000)
		end while Answer.where(token_id: self.token_id).exists?
	end
end
