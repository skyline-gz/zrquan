FactoryGirl.define do
  factory :nq_comment_1, class: Comment do
		content				"问题评论1"
    association :commentable, factory: :newest_question
    association :user, factory: :user_2
    created_at    Time.new(2015,1,1)
  end

  factory :nq_comment_2, class: Comment do
		content				"问题评论2"
    association :commentable, factory: :newest_question
    association :user, factory: :user_2
    created_at    Time.new(2015,1,5)
  end


end
