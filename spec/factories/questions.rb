FactoryGirl.define do
  factory :oldest_question, class: Question do
    title   	      "这是最新的问题吧？"
    content  	      "如题"
    anonymous_flag  false
    association :user, factory: :user_1
    hot             1.12
    publish_date    20150101
    created_at      Time.new(2015,1,1)
  end

  factory :hottest_question, class: Question do
    title   	      "这是最热的问题吧？"
    content  	      "如题"
    anonymous_flag  true
    association :user, factory: :user_2
    hot             10.124
    publish_date    20150102
    created_at      Time.new(2015,1,2)
  end

  factory :real_name_question, class: Question do
		title   	      "怎么写好一份简历？"
    content  	      "如题"
    anonymous_flag  false
    association :user, factory: :user_1
    hot             2.5
    publish_date    20150121
    created_at      Time.new(2015,1,21)
  end

  factory :anonymous_question, class: Question do
		title   	      "匿名来问个问题哈？"
    content  	      "如题"
    anonymous_flag  true
    association :user, factory: :user_1
    hot             5.1
    publish_date    20150128
    created_at      Time.new(2015,1,28)
  end

end
