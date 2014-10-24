# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :private_message do
    content     "私信"
    association :user1, factory: :normal_user_1
    association :user2, factory: :mentor
  end
end
