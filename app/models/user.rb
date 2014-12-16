class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :async

	# 头像上传由异步upload_controller.rb控制,avatar字段只存储头像url
	# mount_uploader :avatar, AvatarUploader

  has_many :questions
  has_many :answers
  has_many :articles
  has_many :messages
  has_many :m_subjects, class_name: "ConsultSubject", foreign_key: "mentor_id"
  has_many :u_subjects, class_name: "ConsultSubject", foreign_key: "apprentice_id"
	has_many :consult_replies
  has_many :comments
	has_many :private_messages
	has_many :invitations
	has_many :invited_questions, class_name: "Question", through: :invitations, source: :question
	has_many :question_follows
	has_many :following_questions, class_name: "Question", through: :question_follows, source: :question
	has_many :bookmarks
	has_many :agreements
	has_many :relationships, foreign_key: "follower_id"
	has_many :following_users, class_name: "User", through: :relationships
	has_many :reverse_relationships, class_name: "Relationship", foreign_key: "following_user_id"
	has_many :followers, class_name: "User", through: :reverse_relationships
  has_one :user_msg_setting
	has_many :user_themes
	has_many :activities
  has_many :careers
  has_many :educations
  has_many :personal_salaries
	has_many :user_attachments
  belongs_to :location
  belongs_to :industry
  belongs_to :latest_company, class_name: "Company"
  belongs_to :latest_school, class_name: "School"

  validates :last_name, :first_name, presence: true, on: :create
  validates :last_name, :first_name, format: {with: /\A\p{Han}+\z|\A[a-zA-Z]+\z/}
  validates :last_name, length: {in: 1..20}, if: Proc.new { |u| u.last_name.match(/\A[a-zA-Z]+\z/) }
  validates :first_name, length: {in: 1..20}, if: Proc.new { |u| u.first_name.match(/\A[a-zA-Z]+\z/) }
  validates :last_name, length: {in: 1..9}, if: Proc.new { |u| u.last_name.match(/\A\p{Han}+\z/) }
  validates :first_name, length: {in: 1..9}, if: Proc.new { |u| u.first_name.match(/\A\p{Han}+\z/) }

  validate :password_complexity
  # 密码长度的验证在config/initializers/devise.rb里面设置（config.password_length）
  # 邮箱格式的验证在config/initializers/devise.rb里面设置（config.email_regexp）

  def password_complexity
    if password.present? and not password.match(/\A[a-zA-Z0-9]+\z/)
      errors.add :password, "can only be input by alphabet and digit."
    end
  end

	def following_num
		following_users.count
	end

	def followers_num
		reverse_relationships.count
	end

	def following_u?(other_user)
		relationships.find_by(following_user_id: other_user.id)
	end

	def following_q?(question)
		question_follows.find_by(question_id: question.id)
	end

	def follow!(other_user)
		logger.debug("follow! method.")
		@relationship = relationships.new
		@relationship.following_user_id = other_user.id
		@relationship.save!
		logger.debug("relationship saved")
		if user_msg_setting.followed_flag
			logger.debug("ready to send message")
			@relationship.following_user.messages.create!(msg_type: 10, extra_info1_id: id, extra_info1_type: "User")
			logger.debug("message created")
		end
	end

	def unfollow(other_user)
		@relationship = relationships.find_by(following_user_id: other_user.id)
		@relationship.destroy
	end

	def bookmarked_q?(question)
		bookmarks = Bookmark.where(user_id: id, bookmarkable_id: question.id, bookmarkable_type: "Question")
		if bookmarks.count > 0
			true
		else
			false
		end
	end

	def bookmarked_a?(article)
		bookmarks = Bookmark.where(user_id: id, bookmarkable_id: article.id, bookmarkable_type: "Article")
		if bookmarks.count > 0
			true
		else
			false
		end
	end

	def answered?(question)
		question.answers.each do |ans|
			if ans.user_id == id
				return true
			end
		end
		false
	end

	def commented_answer?(answer)
		comments = Comment.where(user_id: id, commentable_id: answer.id, commentable_type: "Answer")
		if comments.count > 0
			true
		else
			false
		end
	end

	def commented_article?(article)
		comments = Comment.where(user_id: id, commentable_id: article.id, commentable_type: "Article")
		if comments.count > 0
			true
		else
			false
		end
	end

	def agreed_answer?(answer)
		agreements = Agreement.where(user_id: id, agreeable_id: answer.id, agreeable_type: "Answer")
		if agreements.count > 0
			true
		else
			false
		end
	end

	def agreed_article?(article)
		agreements = Agreement.where(user_id: id, agreeable_id: article.id, agreeable_type: "Article")
		if agreements.count > 0
			true
		else
			false
		end
	end

	def verified_user?
		verified_flag
	end

	def activated?
		confirmed_at == nil ? false : true
	end

	def myself?(other_user)
		id == other_user.id
	end

	def ever_pm?(other_user)
		if id < other_user.id
			pm = PrivateMessage.where(user1_id: id, user2_id: other_user.id)
			pm.count > 0 ? true : false
		else
			pm = PrivateMessage.where(user1_id: other_user.id, user2_id: id)
			pm.count > 0 ? true : false
		end
  end

end
