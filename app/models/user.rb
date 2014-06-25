class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable, :encryptable

  has_many:questions
  has_many:answers
  has_many:articles
  has_many:messages
  has_many:m_subject, class_name: "ConsultSubject", foreign_key: "mentor_id"
  has_many:u_subject, class_name: "ConsultSubject", foreign_key: "apprentice_id"
	has_many:consult_replies
  has_many:comments
	has_many:private_messages
	has_many:invitations, foreign_key: "mentor_id"
	has_many:invited_questions, class_name: "Question", through: :invitations, source: :question
	has_many:bookmark_questions, class_name: "Question", through: :bookmarks
	has_many:relationships, foreign_key: "follower_id"
	has_many:following_users, class_name: "User", through: :relationships
	has_many:reverse_relationships, class_name: "Relationship", foreign_key: "following_user_id"
	has_many:follower, class_name: "User", through: :reverse_relationships
  has_one:user_setting

	def following?(other_user)
		relationships.find_by(following_user_id: other_user.id)
	end

	def follow!(other_user)
		logger.debug("follow! method.")
		@relationship = relationships.new
		@relationship.following_user_id = other_user.id
		@relationship.save!
		logger.debug("relationship saved")
		if user_setting.followed_flag == true
			logger.debug("ready to send message")
			msg_content = last_name + first_name + " is following you."
			@relationship.following_user.messages.create!(content: msg_content, msg_type: 1)
			logger.debug("message created")
		end
	end

	def unfollow(other_user)
		@relationship = relationships.find_by(following_user_id: other_user.id)
		@relationship.destroy
	end

end
