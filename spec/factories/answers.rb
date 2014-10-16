FactoryGirl.define do
  factory :q1_a1 do
		content				"普通用户欧阳俊的答案"
    user_id				1
		question_id		1
		agree_score		30
  end

	factory :q1_a2 do
		content				"受邀导师李小光的答案"
    user_id				6
		question_id		1
		agree_score		20
  end

	factory :q1_a3 do
		content				"受邀导师陈华的答案"
    user_id				5
		question_id		1
		agree_score		25
  end

	factory :q1_a4 do
		content				"普通导师冯庆强的答案"
    user_id				2
		question_id		1
		agree_score		40
  end
end
