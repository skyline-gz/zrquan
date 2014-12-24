require 'ruby-pinyin'

class User < ActiveRecord::Base
	after_create :after_create_user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :async

	# 头像上传由异步upload_controller.rb控制,avatar字段只存储头像url
	# mount_uploader :avatar, AvatarUploader

	searchable do
		text :user_full_name do
			full_name
		end
		text :description, :latest_position, :latest_major
		text :user_latest_company do
			latest_company.try(:name) || ''
		end
		text :user_latest_school do
			latest_school.try(:name) || ''
		end
	end

  has_many :questions
  has_many :answers
  has_many :messages
  has_many :comments
	has_many :private_messages
	has_many :question_follows
	has_many :following_questions, class_name: "Question", through: :question_follows, source: :question
	has_many :bookmarks
	has_many :agreements
	has_many :relationships, foreign_key: "follower_id"
	has_many :following_users, class_name: "User", through: :relationships
	has_many :reverse_relationships, class_name: "Relationship", foreign_key: "following_user_id"
	has_many :followers, class_name: "User", through: :reverse_relationships
  has_one  :user_msg_setting
	has_many :activities
  has_many :careers
  has_many :educations
  has_many :personal_salaries
	has_many :user_attachments
	has_many :answer_drafts
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

	# 根据书写习惯显示姓名
	def full_name
		first_name = self.first_name
		last_name = self.last_name
		if check_english(first_name)|| check_english(last_name)
			last_name + ' ' + first_name
		else
			last_name + first_name
		end
	end

  def password_complexity
    if password.present? and not password.match(/\A[a-zA-Z0-9]+\z/)
      errors.add :password, "can only be input by alphabet and digit."
    end
	end

	# 用于生产客户端通过Faye Sub/Pub的合法token
	def temp_access_token
		Rails.cache.fetch("user-#{self.id}-temp_access_token-#{Time.now.strftime("%Y%m%d")}") do
			SecureRandom.hex
		end
	end

	def unread_messages
		messages.where(read_flag: false)
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

	def bookmarked_q?(question)
		bookmarks = Bookmark.where(user_id: id, bookmarkable_id: question.id, bookmarkable_type: "Question")
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

	def agreed_answer?(answer)
		agreements = Agreement.where(user_id: id, agreeable_id: answer.id, agreeable_type: "Answer")
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

	private
	def randomize_token_id
		self.token_id = 105173 + self.id * 31 + SecureRandom.random_number(31)
	end

	def generate_url_id
		url_id = PinYin.permlink(self.last_name) + '-' + PinYin.permlink(self.first_name)
		if User.find_by_url_id url_id
			url_id += self.id * 17 + SecureRandom.random_number(17)
		end
		self.url_id = url_id
	end

	# 生产用户的设置信息，失败则记录到log
	def generate_user_msg_setting
		unless self.create_user_msg_setting
			logger.error "create user msg setting failure: user_id=" + self.id + " ,user_email=" + self.email
		end
	end

	def after_create_user
		randomize_token_id
		generate_url_id
		self.save
		generate_user_msg_setting
	end

	def check_english(str)
		/\A[a-zA-Z]+\z/.match(str) != nil
	end
end
