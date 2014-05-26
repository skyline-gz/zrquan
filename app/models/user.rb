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
	has_many:invited_questions, class_name: "Question", through: :invitations, foreign_key: "mentor_id"
	has_many:bookmark_questions, class_name: "Question", through: :bookmarks
  belongs_to:user_setting
end
