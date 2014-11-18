# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_theme_stat do
    user nil
    theme nil
    question_count 1
    answer_count 1
    total_agree_score 1
    apply_consult_count 1
    accept_consult_count "MyString"
    fin_mentor_consult_count 1
    mentor_score_sum 1
    score_consult_count 1
    mentor_score_avg 1
    reputation 1
  end
end
