FactoryGirl.define do
  factory :q1_other_answer_1, class: Answer do
		content				"普通用户冯庆强的答案"
    association :user, factory: :normal_user_2
    association :question, factory: :real_name_question
		agree_score		30
  end

	factory :q1_invited_answer_1, class: Answer do
		content				"受邀导师樊宇祺的答案"
    association :user, factory: :v_user_1
    association :question, factory: :real_name_question
		agree_score		20
  end

	factory :q1_invited_answer_2, class: Answer do
		content				"受邀导师林志玲的答案"
    association :user, factory: :v_user_2
    association :question, factory: :real_name_question
		agree_score		25
  end

	factory :q1_other_answer_2, class: Answer do
		content				"普通导师高圆圆的答案"
    association :user, factory: :v_user_3
    association :question, factory: :real_name_question
		agree_score		40
  end
end
