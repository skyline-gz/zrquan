# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    association :user, factory: :normal_user_1
    title       "经验题目"
    content     "经验内容"

    factory :published_article do
      draft_flag  false
    end

    factory :draft_article do
      draft_flag  true
    end
  end

end
