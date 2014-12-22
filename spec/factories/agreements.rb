# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :agreement do
    association :user, factory: :normal_user_1

    factory :answer_agree do
      association :agreeable, factory: :q1_other_answer_1
    end

  end

end
