class Ability
  include CanCan::Ability

  def initialize(user)
		# user not login
		if user == nil
			logout_unactivate_abilities(user)
		# unactivated user
		elsif !user.activated?
			logout_unactivate_abilities(user)
		# verified_user
		elsif user.verified_user?
			verified_user_abilities(user)
		# normal user
		else
			normal_user_abilities(user)
		end
  end

	private
		# logout & unactivated user
		def logout_unactivate_abilities(user)
      cannot :manage, :all
      # read only
      can :show, Question
      can :show, Answer
      can :show, Article
      can :show, Comment
      can :show, UserSetting
      can :show, Bookmark
      can :show, Message
      can :show, NewsFeed
      can :show, Activity
		end

		# verified_user
		def verified_user_abilities(user)
			# general 
			create_edit_abilities(user)

      # special consult abilities
      can :show, ConsultSubject do |cs|
        cs.mentor_id == user.id or cs.apprentice_id == user.id
      end
      can [:accept, :ignore], ConsultSubject, :mentor_id=>user.id, :stat_class=>1
      can [:reply, :close], ConsultSubject  do |cs|
        (cs.mentor_id == user.id or cs.apprentice_id == user.id) and cs.in_progress?
      end
      can :edit, ConsultSubject do |cs|
        cs.apprentice_id == user.id and cs.in_progress?
      end
      can :edit, ConsultReply do |cr|
        cr.user_id == user.id and cr.consult_subject.in_progress?
      end
      can :consult, User do |u|
        u.verified_user? and !user.myself?(u)
      end

      # answer
      answer_abilities(user)
      # article
      article_abilities(user)
			# pm
      pm_abilities(user)
      # bookmark
      bookmark_abilities(user)
			# user relationship
      follow_abilities(user)
		end

    # normal user
    def normal_user_abilities(user)
			# general 
			create_edit_abilities(user)
			
      # special consult abilities
      can :show, ConsultSubject, :apprentice_id=>user.id
      cannot :accept, ConsultSubject
      can [:reply, :close], ConsultSubject, :apprentice_id=>user.id, :stat_class=>2
      can :edit, ConsultSubject do |cs|
        cs.apprentice_id == user.id and cs.in_progress?
      end
      can :edit, ConsultReply do |cr|
        cr.user_id == user.id and cr.consult_subject.in_progress?
      end
      can :consult, User do |u|
        u.verified_user?
      end

      # answer
      answer_abilities(user)
      # article
      article_abilities(user)
			# pm
      pm_abilities(user)
      # bookmark
      bookmark_abilities(user)
			# user relationship
      follow_abilities(user)
		end

    def create_edit_abilities(user)
      can :create, :all
      cannot :create, [Message, UserSetting]
      can :edit, [Question, Answer, UserSetting], :user_id => user.id
      can :edit, User, :id => user.id
    end

    def answer_abilities(user)
      can :answer, Question do |q|
        !user.answered?(q) and q.user_id != user.id
      end
      can :agree, Answer do |ans|
        ans.user_id != user.id and !user.agreed_answer?(ans)
      end
      can :comment, Answer
    end

    def article_abilities(user)
      can :agree, Article do |a|
        a.user_id != user.id and !user.agreed_article?(a) and !a.draft?
      end
      can :comment, Article, :draft_flag => false
      can :edit, Article, :user_id => user.id
      can :destroy, Article, :user_id => user.id, :draft_flag => true
    end

    def follow_abilities(user)
      can :follow, User do |target_user|
        !user.myself?(target_user) and !user.following?(target_user)
      end
      can :unfollow, User do |target_user|
        user.following?(target_user)
      end
    end

    def pm_abilities(user)
      can :pm, User do |target_user|
        target_user.following?(user) or target_user.ever_pm?(user)
      end
    end

    def bookmark_abilities(user)
      can :bookmark, Question do |q|
        !user.bookmarked_q?(q)
      end
      can :unbookmark, Question do |q|
        user.bookmarked_q?(q)
      end
      can :bookmark, Article do |a|
        !user.bookmarked_a?(a) and !a.draft?
      end
      can :unbookmark, Article do |a|
        user.bookmarked_a?(a) and !a.draft?
      end
    end
end
