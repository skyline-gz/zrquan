FactoryGirl.define do
  factory :nq_real_name_answer, class: Answer do
		content				"最佳的答案啊啊啊啊"
    association :user, factory: :user_2
    association :question, factory: :newest_question
		agree_score		30
    oppose_score  10
    actual_score  20
    anonymous_flag  false
    created_at    Time.new(2015,1,1)
  end

  factory :nq_hottest_answer, class: Answer do
		content				"普通用户冯庆强的答案"
    association :user, factory: :user_4
    association :question, factory: :newest_question
		agree_score		30
    oppose_score  8
    actual_score  22
    anonymous_flag  true
    created_at    Time.new(2015,1,4)
  end

  factory :nq_newest_answer, class: Answer do
		content				"普通用户冯庆强的答案"
    association :user, factory: :user_3
    association :question, factory: :newest_question
		agree_score		30
    oppose_score  20
    actual_score  10
    anonymous_flag  false
    created_at    Time.new(2015,1,21)
  end

  factory :hq_real_name_answer, class: Answer do
    content				"普通用户冯庆强的答案"
    association :user, factory: :user_1
    association :question, factory: :hottest_question
    agree_score		30
    oppose_score  10
    actual_score  20
    anonymous_flag  false
    created_at    Time.new(2015,1,1)
  end

  factory :hq_anonymous_answer, class: Answer do
    content				"普通用户冯庆强的答案"
    association :user, factory: :user_1
    association :question, factory: :hottest_question
    agree_score		40
    oppose_score  9
    actual_score  31
    anonymous_flag  true
    created_at    Time.new(2015,1,20)
  end

  factory :rq_anonymous_answer, class: Answer do
    content				"普通用户冯庆强的答案"
    association :user, factory: :user_1
    association :question, factory: :real_name_question
    agree_score		50
    oppose_score  19
    actual_score  31
    anonymous_flag  false
    created_at    Time.new(2015,1,20)
  end

end
