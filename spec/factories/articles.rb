# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :published_article, class: Article do
    association :user, factory: :normal_user_1
    title       "经验题目"
    content     "经验内容"
    draft_falg  false
  end

  factory :draft_article, class: Article do
    association :user, factory: :normal_user_1
    title       "草稿经验题目"
    content     "草稿经验内容"
    draft_falg  true
  end
end
