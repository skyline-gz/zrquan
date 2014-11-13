# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :education do
    user nil
    school nil
    major "MyString"
    graduate_year "MyString"
    description "MyText"
  end
end
