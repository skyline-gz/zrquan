require 'bcrypt'
require 'regex_expression'
require 'sql_utils'
require 'user_sql'

class User < ActiveRecord::Base
  include BCrypt
	after_create :after_create_user

	# 头像上传由异步upload_controller.rb控制,avatar字段只存储头像url
	# mount_uploader :avatar, AvatarUploader

	searchable do
   text :name, :description
   text :company do
      latest_company_name
   end
   text :position do
      latest_position
   end
   text :school do
      latest_school_name
   end
   text :major do
      latest_major
   end
	end

  has_many :questions
  has_many :answers
  has_many :posts
  has_many :post_comments
  has_many :messages
  has_many :comments
	has_many :private_messages
	has_many :question_follows
	has_many :following_questions, class_name: "Question", through: :question_follows, source: :question
	has_many :bookmarks
	has_many :agreements
	has_many :oppositions
	has_many :relationships, foreign_key: "follower_id"
	# has_many :following_users, class_name: "User", through: :relationships
	has_many :reverse_relationships, class_name: "Relationship", foreign_key: "following_user_id"
	# has_many :followers, class_name: "User", through: :reverse_relationships
  has_one  :user_msg_setting
	has_many :activities
  has_many :careers
  has_many :educations
	has_many :user_attachments
	has_many :answer_drafts
  has_many :theme_follows
  belongs_to :location
  belongs_to :industry
  belongs_to :latest_career, class_name: "Career"
  belongs_to :latest_education, class_name: "Education"

  validates :name, presence: true, on: :create
  validates :name, format: {with: /\A\p{Han}+\z|\A[a-zA-Z]+\z/}
  validates :name, length: {in: 1..30}, if: Proc.new { |u| u.name.match(/\A[a-zA-Z]+\z/) }
  validates :name, length: {in: 1..10}, if: Proc.new { |u| u.name.match(/\A\p{Han}+\z/) }
  validates :description, length: {maximum: 25}

  def password
    Password.new(self.encrypted_password)
  end

  def password=(new_password)
    self.encrypted_password = Password.create(new_password)
  end

  def self.password_validate?(new_password)
    (RegexExpression::PASSWORD.match new_password) != nil
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

  # 关注人数
	def following_num
    relationships.count
	end

  # 粉丝数
	def followers_num
		reverse_relationships.count
  end

  # 问过(数量)
  def questions_num
    answers.count
  end

  # 答过(数量)
  def answers_num
    questions.count
  end

  # 说过(数量)
  def posts_num
    posts.count
  end

  # 跟踪问题数量
  def f_questions_num
    question_follows.count
  end

  # 跟踪主题数量
  def f_themes_num
    theme_follows.count
  end

  # 收藏数量
  def bookmarks_num
    bookmarks.count
  end

  # 草稿数量
  def drafts_num
    answer_drafts.count
  end

  # 声望
  def reputation
    reputation = 0
    reputation = reputation + answer_ag * 4 + post_ag * 2 + post_comment_ag * 2
    reputation = reputation - answer_op - post_op - post_comment_op
    reputation > 0 ? reputation : 0
  end

  # 于某问题上下文环境身份
  def question_identity(question)
    identity = "none"
    q = Question.find_by(user_id:id, id:question.id)
    if q != nil
      identity = q.anonymous_flag ? "anonymous" : "real"
    else
      answers = Answer.where(user_id:id, question_id:question.id)
      if answers.count > 0
        identity = "real"
        answers.each do |a|
          if a.anonymous_flag
            identity = "anonymous"
            break
          end
        end
      end
    end
    identity
  end

  def post_identity(post)
    identity = "none"
    p = Post.find_by(user_id:id, id:post.id)
    if p != nil
      identity = p.anonymous_flag ? "anonymous" : "real"
    else
      post_comments = PostComment.where(user_id:id, post_id:post.id)
      if post_comments.count > 0
        identity = "real"
        post_comments.each do |pc|
          if pc.anonymous_flag
            identity = "anonymous"
            break
          end
        end
      end
    end
    identity
  end

  def answer_ag
    finished_sql = SqlUtils.escape_sql(UserSql::ANSWER_AG, id)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["num"]
  end

  def post_ag
    finished_sql = SqlUtils.escape_sql(UserSql::POST_AG, id)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["num"]
  end

  def post_comment_ag
    finished_sql = SqlUtils.escape_sql(UserSql::POST_COMMENT_AG, id)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["num"]
  end

  def answer_op
    finished_sql = SqlUtils.escape_sql(UserSql::ANSWER_OP, id)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["num"]
  end

  def post_op
    finished_sql = SqlUtils.escape_sql(UserSql::POST_OP, id)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["num"]
  end

  def post_comment_op
    finished_sql = SqlUtils.escape_sql(UserSql::POST_COMMENT_OP, id)
    result = ActiveRecord::Base.connection.select_all(finished_sql)
    result[0]["num"]
  end

  def following_u?(other_user)
    relationships.find_by(following_user_id: other_user.id)
  end

  def following_q?(question)
    question_follows.find_by(question_id: question.id)
  end

  def following_t?(theme)
    theme_follows.find_by(theme_id: theme.id)
  end

  # 问过list
  def questions_list
    finished_sql = SqlUtils.escape_sql(UserSql::QUESTIONS_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 说过list
  def posts_list
    finished_sql = SqlUtils.escape_sql(UserSql::POSTS_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 答过list
  def answers_list
    finished_sql = SqlUtils.escape_sql(UserSql::ANSWERS_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 跟踪问题list
  def f_questions_list
    finished_sql = SqlUtils.escape_sql(UserSql::F_QUESTIONS_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 关注主题list
  def f_themes_list
    finished_sql = SqlUtils.escape_sql(UserSql::F_THEMES_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 草稿list
  def drafts_list
    finished_sql = SqlUtils.escape_sql(UserSql::DRAFTS_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 职业经历list
  def career_list
    finished_sql = SqlUtils.escape_sql(UserSql::CAREER_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 教育经历list
  def education_list
    finished_sql = SqlUtils.escape_sql(UserSql::EDUCATION_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def bookmarked_questions
    finished_sql = SqlUtils.escape_sql(UserSql::BOOKMARKED_QUESTIONS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def bookmarked_posts
    finished_sql = SqlUtils.escape_sql(UserSql::BOOKMARKED_POSTS, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 粉丝list
  def followers_list
    finished_sql = SqlUtils.escape_sql(UserSql::FOLLOWERS_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  # 关注list
  def following_list
    finished_sql = SqlUtils.escape_sql(UserSql::FOLLOWING_LIST, id)
    ActiveRecord::Base.connection.select_all(finished_sql)
  end

  def bookmarked_question?(question)
    bookmarks = Bookmark.where(user_id: id, bookmarkable_id: question.id, bookmarkable_type: "Question")
    bookmarks.count > 0 ? true : false
  end

  def bookmarked_post?(post)
    bookmarks = Bookmark.where(user_id: id, bookmarkable_id: post.id, bookmarkable_type: "Post")
    bookmarks.count > 0 ? true : false
  end

	def answered?(question)
    answer_count = question.answers.where(user_id:id).count
    answer_count > 0 ? true : false
	end

	def commented_answer?(answer)
		comments = Comment.where(user_id: id, commentable_id: answer.id, commentable_type: "Answer")
		comments.count > 0 ? true : false
	end

	def agreed_answer?(answer)
		agreements = Agreement.where(user_id: id, agreeable_id: answer.id, agreeable_type: "Answer")
    agreements.count > 0 ? true : false
  end

	def agreed_post?(post)
		agreements = Agreement.where(user_id: id, agreeable_id: post.id, agreeable_type: "Post")
		agreements.count > 0 ? true : false
  end

	def agreed_post_comment?(post_comment)
		agreements = Agreement.where(user_id: id, agreeable_id: post_comment.id, agreeable_type: "PostComment")
    agreements.count > 0 ? true : false
  end

	def opposed_answer?(answer)
		opposition = Opposition.where(user_id: id, opposable_id: answer.id, opposable_type: "Answer")
    opposition.count > 0 ? true : false
  end

	def opposed_post?(post)
		opposition = Opposition.where(user_id: id, opposable_id: post.id, opposable_type: "Post")
    opposition.count > 0 ? true : false
  end

	def opposed_post_comment?(post_comment)
		opposition = Opposition.where(user_id: id, opposable_id: post_comment.id, opposable_type: "PostComment")
    opposition.count > 0 ? true : false
	end

	def verified_user?
		verified_flag
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
	# def randomize_token_id
	# 	self.token_id = 105173 + self.id * 31 + SecureRandom.random_number(31)
	# end

	# def generate_url_id
	# 	url_id = PinYin.permlink(self.last_name) + '-' + PinYin.permlink(self.first_name)
	# 	if User.find_by_url_id url_id
	# 		url_id += self.id * 17 + SecureRandom.random_number(17)
	# 	end
	# 	self.url_id = url_id
	# end

	# 生产用户的设置信息，失败则记录到log
	def generate_user_msg_setting
		unless self.create_user_msg_setting
			logger.error "create user msg setting failure: user_id=" + self.id + " ,user_email=" + self.email
		end
	end

	def after_create_user
		# randomize_token_id
		# generate_url_id
		# self.save
		generate_user_msg_setting
	end

	def check_english(str)
		/\A[a-zA-Z]+\z/.match(str) != nil
  end

end
