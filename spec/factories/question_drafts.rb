# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_draft do
    title "MyString"
    content "MyText"
    user nil
  end
end
