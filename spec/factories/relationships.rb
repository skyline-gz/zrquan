# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relationship do
    association :user, factory: :normal_user_1
    association :agreeable, factory: :q1_other_answer_1
  end

end
