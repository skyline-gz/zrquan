class Ability
  include CanCan::Ability

  def initialize(user)
		# user not login
		if user == nil
			logout_unactivate_abilities(user)
		# unactivated user
		elsif !user.activated?
			logout_unactivate_abilities(user)
		# # verified_user
		# elsif user.verified_user?
		# 	verified_user_abilities(user)
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
      can :show, Comment
      can :show, UserMsgSetting
      can :show, Bookmark
      can :show, Message
      can :show, NewsFeed
      can :show, Activity
      can :show, Post
      can :show, PostComment
		end

		# # verified_user
		# def verified_user_abilities(user)
		# 	# general
     #  user_related_abilities(user)
    #
     #  # answer
     #  answer_abilities(user)
     #  # comment
     #  comment_abilities(user)
		# 	# pm
     #  pm_abilities(user)
     #  # bookmark
     #  bookmark_abilities(user)
		# 	# user relationship
     #  follow_abilities(user)
		# end

    # normal user
    def normal_user_abilities(user)
			# general 
      user_related_abilities(user)
			
      # answer
      answer_abilities(user)
      # post
      post_abilities(user)
      post_comment_abilities(user)
      # comment
      comment_abilities(user)
			# pm
      pm_abilities(user)
      # bookmark
      bookmark_abilities(user)
			# follow
      follow_abilities(user)
		end

    def comment_abilities(user)
      can :comment, Answer
      can :comment, Question
      can :delete, Comment do |c|
        user.id == c.user.id
      end
    end

    def user_related_abilities(user)
      can :create, User
      can :edit, User, :id => user.id
      can :edit, UserMsgSetting, :user_id => user.id
    end

    def question_abilities(user)
      can :create, Question
      can :follow, Question
      can :edit, Question, :user_id => user.id
      can :switch_identity, Question do |q|
        question_identity(q) != -1
      end
    end

    def answer_abilities(user)
      can :answer, Question do |q|
        !user.answered?(q) and q.user_id != user.id
      end
      can :edit, Answer, :user_id => user.id
      can :agree, Answer do |a|
        a.user_id != user.id and !user.agreed_answer?(a)
      end
      can :cancel_agree, Answer do |a|
        a.user_id != user.id and user.agreed_answer?(a)
      end
      can :oppose, Answer do |a|
        a.user_id != user.id and !user.opposed_answer?(a)
      end
      can :cancel_oppose, Answer do |a|
        a.user_id != user.id and user.opposed_answer?(a)
      end
    end

    def post_abilities(user)
      can :create, Post
      can :agree, Post do |p|
        p.user_id != user.id and !user.agreed_post?(p)
      end
      can :cancel_agree, Post do |p|
        p.user_id != user.id and user.agreed_post?(p)
      end
      can :oppose, Post do |p|
        p.user_id != user.id and !user.opposed_post?(p)
      end
      can :cancel_oppose, Post do |p|
        p.user_id != user.id and user.opposed_post?(p)
      end
      can :switch_identity, Post do |p|
        post_identity(p) != -1
      end
    end

    def post_comment_abilities(user)
      can :comment, Post
      can :delete, PostComment do |pc|
        user.id == pc.user.id
      end
    end

    def follow_abilities(user)
      can :follow, User do |target_user|
        !user.myself?(target_user) and !user.following_u?(target_user)
      end
      can :unfollow, User do |target_user|
        user.following_u?(target_user)
      end
			can :follow, Question do |q|
				!user.following_q?(q)
			end
			can :un_follow, Question do |q|
				user.following_q?(q)
			end
    end

    def pm_abilities(user)
      can :pm, User do |target_user|
        target_user.following_u?(user) or target_user.ever_pm?(user)
      end
    end

    def bookmark_abilities(user)
      can :bookmark, Question do |q|
        !user.bookmarked_q?(q)
      end
      can :unbookmark, Question do |q|
        user.bookmarked_q?(q)
      end
      can :bookmark, Post do |p|
        !user.bookmarked_q?(p)
      end
      can :unbookmark, Post do |p|
        user.bookmarked_q?(p)
      end
    end
end
