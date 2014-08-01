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
		# not login
		def logout_abilities(user)
			cannot :create, :all
			cannot :edit, :all
			cannot :destroy, :all
			cannot :agree, [Answer, Article]
			cannot :accept, ConsultSubject
			cannot :bookmark, :all
		end

		# mentor
		def mentor_abilities(user)
			# general 
			can :create, :all
			cannot :create, [Question, ConsultSubject, Invitation, Message, UserSetting]
			can :edit, [Answer, UserSetting], :user_id=>user.id
			can :edit, User, :id=>user.id
			cannot :edit, [Question, ConsultSubject]

			# special QA abilities
			can :answer, Question do |q|
				!user.answered?(q) and q.user_id != user.id
			end
			can :agree, Answer do |ans|
				ans.user_id != user.id
			end
			can :bookmark, Question do |q|
				!user.bookmarked_q?(q)
			end			
			can :unbookmark, Question do |q|
				user.bookmarked_q?(q)
			end
			can :comment, Answer do |ans|
				ans.user_id != user.id
			end

			# special article abilities
			can :agree, Article do |art|
				art.user_id != user.id
			end
			can :comment, Article do |art|
				art.user_id != user.id
			end
			can :bookmark, Article do |a|
				!user.bookmarked_a?(a)
			end
			can :unbookmark, Article do |a|
				user.bookmarked_a?(a)
			end
			can :edit, Article, :user_id=>user.id, :draft_flag=>true
			can :destroy, Article, :user_id=>user.id, :draft_flag=>true

			# special consult abilities
			can :show, ConsultSubject, :mentor_id=>user.id
			can :reply, ConsultSubject, :mentor_id=>user.id, :stat_class=>2
			can [:accept, :ignore], ConsultSubject, :mentor_id=>user.id, :stat_class=>1
			can :close, ConsultSubject, :mentor_id=>user.id, :stat_class=>2
			can :edit, ConsultReply do |cr|
				cr.user_id == user.id and cr.consult_subject.stat_class != 3
			end
			cannot :consult, User
						
			# user relationship
			can :follow, User do |target_user|
				!user.myself?(target_user) and !user.following?(target_user)
			end
			can :unfollow, User do |target_user|
				user.following?(target_user)
			end
		end

		# normal user
		def normal_user_abilities(user)
			# general 
			can :create, :all
			cannot :create, [Message, UserSetting]
			can :edit, [Question, Answer, UserSetting], :user_id=>user.id
			can :edit, User, :id=>user.id
			
			# special QA abilities
			can :answer, Question do |q|
				!user.answered?(q) and q.user_id != user.id
			end
			can :agree, Answer do |ans|
				ans.user_id != user.id
			end
			can :comment, Answer do |ans|
				ans.user_id != user.id
			end
			can :bookmark, Question do |q|
				!user.bookmarked_q?(q)
			end
			can :unbookmark, Question do |q|
				user.bookmarked_q?(q)
			end

			# special article abilities
			can :agree, Article do |art|
				art.user_id != user.id
			end
			can :comment, Article do |art|
				art.user_id != user.id
			end
			can :bookmark, Article do |a|
				!user.bookmarked_a?(a)
			end
			can :unbookmark, Article do |a|
				user.bookmarked_a?(a)
			end
			can :edit, Article, :user_id=>user.id, :draft_flag=>true
			can :destroy, Article, :user_id=>user.id, :draft_flag=>true		

			# special consult abilities
			can :show, ConsultSubject, :apprentice_id=>user.id
			can :reply, ConsultSubject, :apprentice_id=>user.id, :stat_class=>2
			can :edit, ConsultSubject do |cs|
				cs.apprentice_id == user.id and cs.stat_class != 3
			end
			can :edit, ConsultReply do |cr|
				cr.user_id == user.id and cr.consult_subject.stat_class != 3
			end
			can :close, ConsultSubject, :apprentice_id=>user.id, :stat_class=>2
			can :consult, User do |u|
				u.mentor?
			end
			cannot :accept, ConsultSubject

			# user relationship
			can :follow, User do |target_user|
				!user.myself?(target_user) and !user.following?(target_user)
			end
			can :unfollow, User do |target_user|
				user.following?(target_user)
			end
		end
end
