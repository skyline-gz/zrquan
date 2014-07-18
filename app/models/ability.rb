class Ability
  include CanCan::Ability

  def initialize(user)
		# user not login
		if user == nil
			logout_abilities(user)
		# unactivated user
		#elsif !user.activated?
		#	cannot :create, :all
		#	cannot :edit, :all
		#	cannot :destroy, :all
		#	cannot :agree, [Answer, Article]
		#	cannot :accept, ConsultSubject
		# mentor
		elsif user.mentor?
			mentor_abilities(user)
		# normal user
		else
			normal_user_abilities(user)
		end
  end

	private
		def logout_abilities(user)
			cannot :create, :all
			cannot :edit, :all
			cannot :destroy, :all
			cannot :agree, [Answer, Article]
			cannot :accept, ConsultSubject
		end

		def mentor_abilities(user)
			can :create, :all
			cannot :create, [Question, ConsultSubject, Invitation, Message, UserSetting]
			can :answer, Question do |q|
				!user.answered?(q)
			end
			can :agree, [Answer, Article]
			can :accept, ConsultSubject
			can :edit, [Answer, Article, ConsultReply, UserSetting], :user_id=>user.id
			cannot :edit, [Question, ConsultSubject]
			can :destroy, Article, :user_id=>user.id, :draft_flag=>true
			can :follow, User do |target_user|
				!user.myself?(target_user) and !user.following?(target_user)
			end
			can :unfollow, User do |target_user|
				user.following?(target_user)
			end
		end

		def normal_user_abilities(user)
			can :create, :all
			cannot :create, [Message, UserSetting]
			can :answer, Question do |q|
				!user.answered?(q)
			end
			can :agree, [Answer, Article]
			can :edit, [Question, Answer, Article, ConsultReply, UserSetting], :user_id=>user.id
			can :edit, ConsultSubject, :apprentice_id=>user.id
			can :destroy, Article, :user_id=>user.id, :draft_flag=>true
			can :follow, User do |target_user|
				!user.myself?(target_user) and !user.following?(target_user)
			end
			can :unfollow, User do |target_user|
				user.following?(target_user)
			end
			cannot :accept, ConsultSubject
		end
end
