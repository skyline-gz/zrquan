# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relationship do
    association :following_user, factory: :user_1
    association :follower, factory: :user_3
  end

end
