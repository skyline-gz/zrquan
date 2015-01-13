# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relationship do
    association :following_user, factory: :normal_user_1
    association :follower, factory: :v_user_1
  end

end
