# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :career do
    user nil
    industry nil
    company nil
    position "MyString"
    entry_year "MyString"
    entry_month "MyString"
    leave_year "MyString"
    leave_month "MyString"
    description "MyText"
  end
end
