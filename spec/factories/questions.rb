FactoryGirl.define do
  factory :real_name_question, class: Question do
		title   	      "怎么写好一份简历？"
    content  	      "如题"
    anonymous_flag  false
    association :user, factory: :normal_user_1
  end

  factory :anonymous_question, class: Question do
		title   	      "匿名来问个问题哈？"
    content  	      "如题"
    anonymous_flag  true
    association :user, factory: :normal_user_1
  end
end
