class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :encryptable

  has_many:questions
  has_many:answers
  has_many:experience_articles
  has_many:messages
  has_many:m_consultant_subject, class_name: "ConsultantSubject", foreign_key: "mentor_id"
  has_many:u_consultant_subject, class_name: "ConsultantSubject", foreign_key: "apprentice_id"
  has_many:comments
end
