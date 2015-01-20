require 'bcrypt'
require 'regex_expression'

class User < ActiveRecord::Base
  include BCrypt
	after_create :after_create_user

	# 头像上传由异步upload_controller.rb控制,avatar字段只存储头像url
	# mount_uploader :avatar, AvatarUploader

	searchable do
   text :name, :description
   text :company do
      latest_company
   end
   text :position do
      latest_position
   end
   text :school do
      latest_school
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
	has_many :following_users, class_name: "User", through: :relationships
	has_many :reverse_relationships, class_name: "Relationship", foreign_key: "following_user_id"
	has_many :followers, class_name: "User", through: :reverse_relationships
  has_one  :user_msg_setting
	has_many :activities
  has_many :careers
  has_many :educations
	has_many :user_attachments
	has_many :answer_drafts
  belongs_to :location
  belongs_to :industry
  belongs_to :latest_career, class_name: "Career"
  belongs_to :latest_education, class_name: "Education"

  validates :name, presence: true, on: :create
  validates :name, format: {with: /\A\p{Han}+\z|\A[a-zA-Z]+\z/}
  validates :name, length: {in: 1..30}, if: Proc.new { |u| u.name.match(/\A[a-zA-Z]+\z/) }
  validates :name, length: {in: 1..10}, if: Proc.new { |u| u.name.match(/\A\p{Han}+\z/) }
  validates :description, length: {maximum: 25}

  def password_hash
    self.encrypted_password
  end

  def password=(new_password)
    password_hash = Password.create(new_password)
    self.encrypted_password = password_hash
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

  def latest_company
    latest_career != nil ? latest_career.company.name : ""
  end

  def latest_position
    latest_career != nil ? latest_career.position : ""
  end

  def latest_school
    latest_education != nil ? latest_education.school.name : ""
  end

  def latest_major
    latest_education != nil ? latest_education.major : ""
  end

  # 关注人数
	def following_num
    relationships.count
	end

  # 粉丝数
	def followers_num
		reverse_relationships.count
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
    identity = -1
    q = Question.where(user_id:id, id:question.id)
    if q.count > 0
      identity = q.anonymous_flag ? 1 : 0
    else
      answers = Answer.where(user_id:id, question_id:question.id)
      if answers.count > 0
        answers.each do |a|
          if a.anonymous_flag
            identity = 1
          end
        end
        identity = 0
      end
    end
    identity
  end

  def post_identity(post)
    identity = -1
    p = Post.where(user_id:id, id:post.id)
    if p.count > 0
      identity = p.anonymous_flag ? 1 : 0
    else
      posts = PostComment.where(user_id:id, post_id:post.id)
      if posts.count > 0
        posts.each do |p|
          if p.anonymous_flag
            identity = 1
          end
        end
        identity = 0
      end
    end
    identity
  end

  def answer_ag
    result = ActiveRecord::Base.connection.select_all(
        ["select 'a' as type, count(an.id) as num
          from OPPOSITIONS op inner join ANSWERS an on op.opposable_id = an.id
          where
            op.opposable_type = 'Answer' and
            an.anonymous_flag = 0 and
            an.user_id = ?", id])
    result[0]["num"]
  end

  def post_ag
    result = ActiveRecord::Base.connection.select_all(
        ["select 'p' as type, count(po.id) as num
          from AGREEMENTS ag inner join POSTS po on ag.agreeable_id = po.id
          where
            ag.agreeable_type = 'Post' and
            po.anonymous_flag = 0 and
            po.user_id = ?", id])
    result[0]["num"]
  end

  def post_comment_ag
    result = ActiveRecord::Base.connection.select_all(
        ["select 'a' as type, count(an.id) as num
          from OPPOSITIONS op inner join ANSWERS an on op.opposable_id = an.id
          where
            op.opposable_type = 'Answer' and
            an.anonymous_flag = 0 and
            an.user_id = ?", id])
    result[0]["num"]
  end

  def answer_op
    result = ActiveRecord::Base.connection.select_all(
        ["select 'a' as type, count(an.id) as num
          from OPPOSITIONS op inner join ANSWERS an on op.opposable_id = an.id
          where
            op.opposable_type = 'Answer' and
            an.anonymous_flag = 0 and
            an.user_id = ?", id])
    result[0]["num"]
  end

  def post_op
    result = ActiveRecord::Base.connection.select_all(
        ["select 'p' as type, count(po.id) as num
          from OPPOSITIONS op inner join POSTS po on op.opposable_id = po.id
          where
            op.opposable_type = 'Post' and
            po.anonymous_flag = 0 and
            po.user_id = ?", id])
    result[0]["num"]
  end

  def post_comment_op
    result = ActiveRecord::Base.connection.select_all(
        ["select 'c' as type, count(co.id) as num
          from OPPOSITIONS op inner join POST_COMMENTS co on op.opposable_id = co.id
          where
            op.opposable_type = 'PostComment' and
            co.anonymous_flag = 0 and
            co.user_id = ?", id])
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

  def bookmarked_question?(question)
    bookmarks = Bookmark.where(user_id: id, bookmarkable_id: question.id, bookmarkable_type: "Question")
    bookmarks.count > 0 ? true : false
  end

  def bookmarked_post?(post)
    bookmarks = Bookmark.where(user_id: id, bookmarkable_id: post.id, bookmarkable_type: "Post")
    bookmarks.count > 0 ? true : false
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
