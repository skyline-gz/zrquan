FactoryGirl.define do
  factory :question_1, class: Question do
		title   	"怎么写好一份简历？"
    content  	"如题"
    association :user, factory: :normal_user_1
  end
end
