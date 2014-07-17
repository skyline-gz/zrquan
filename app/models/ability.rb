class Ability
  include CanCan::Ability

  def initialize(user)
		# user not login
		if user != nil

		# unconfirmed user
		elsif !user.confirmed?
			cannot :create, :all
			cannot :edit, :all
			cannot :destroy, :all
			cannot :agree, [Answer, Article]
			cannot :accept, ConsultSubject
		# mentor
		elsif user.mentor?
			can :create, :all
			cannot :create, [Question, ConsultSubject, Invitation, Message, UserSetting]
			can :agree, [Answer, Article]
			can :accept, ConsultSubject
			can :edit, [Answer, Article, ConsultReply, UserSetting], :user_id=>user.id
			cannot :edit, [Question, ConsultSubject]
			can :destroy, Article, :user_id=>user.id, :draft_flag=>true
		# normal user
		else
			can :create, :all
			cannot :create, [Message, UserSetting]
			can :agree, [Answer, Article]
			can :edit, [Question, Answer, Article, ConsultReply, UserSetting], :user_id=>user.id
			can :edit, ConsultSubject, :apprentice_id=>user.id
			can :destroy, Article, :user_id=>user.id, :draft_flag=>true
			cannot :accept, ConsultSubject
		end
  end
end
