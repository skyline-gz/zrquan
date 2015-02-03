require 'rails_helper'

RSpec.describe Question, :type => :model do
	context "with more than 2 answers" do
    let (:user1) {FactoryGirl.create(:user_1)}
    let (:user2) {FactoryGirl.create(:user_2)}
    let (:question) {FactoryGirl.create(:newest_question, :user=>user1)}

    it "multiple answers should sorted by agree scores desc" do
      hottest_an = FactoryGirl.create(:nq_hottest_answer, :question=>question)
      newest_an = FactoryGirl.create(:nq_newest_answer, :question=>question)
      real_name_an = FactoryGirl.create(:nq_real_name_answer, :question=>question)
      sorted_answers = question.sorted_answers
      expect(sorted_answers[0]["id"]).to eq(hottest_an.id)
      expect(sorted_answers[1]["id"]).to eq(real_name_an.id)
      expect(sorted_answers[2]["id"]).to eq(newest_an.id)
    end

    it "multiple comments should sorted by create time desc" do
      older_comment = FactoryGirl.create(:nq_comment_1, :commentable=>question, :user=>user2)
      newer_comment = FactoryGirl.create(:nq_comment_2, :commentable=>question, :user=>user2)
      sorted_comments = question.sorted_comments
      expect(sorted_comments[0]["id"]).to eq(newer_comment.id)
      expect(sorted_comments[1]["id"]).to eq(older_comment.id)
    end

    # it "invited mentors' answers should before other users' answers " do
    # end

    # it "multiple invited mentors' answers should sorted by agree scores desc " do
    # end

    # it "should sort answers according to the rules above when there multiple invited answers and normal answers" do
    # end
  end
end
