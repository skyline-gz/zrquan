# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bookmark do
    association :user, factory: :user_1

    factory :question_bookmark do
      association :bookmarkable, factory: :real_name_question
    end

  end
end
