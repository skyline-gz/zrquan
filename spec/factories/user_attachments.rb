# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_attachment do
    user nil
    attachable nil
    url "MyString"
    size 1
  end
end
