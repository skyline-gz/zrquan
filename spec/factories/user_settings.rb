# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_msg_setting do
    association :user, factory: :user_1
  end
end
