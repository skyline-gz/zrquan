# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    association :user, factory: :normal_user_1
    title       "经验题目补完字数"
    content     "十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多十个字的经验内容很多"

    factory :published_article do
      draft_flag  false
    end

    factory :draft_article do
      draft_flag  true
    end
  end

end
