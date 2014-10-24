# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_bookmark, class: Bookmark do
    association :user, factory: :normal_user_1
    association :bookmarkable, factory: :question_1
  end

  factory :article_bookmark, class: Bookmark do
    association :user, factory: :normal_user_1
    association :bookmarkable, factory: :published_article
  end

end
