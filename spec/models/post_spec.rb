require 'rails_helper'

RSpec.describe Post, :type => :model do
  context "with more than 2 post comments" do
    let (:user1) {FactoryGirl.create(:user_1)}
    let (:user2) {FactoryGirl.create(:user_2)}
    let (:user3) {FactoryGirl.create(:user_3)}
    let (:post) {FactoryGirl.create(:post_1, :user=>user1)}
    let (:post_comment_1) {FactoryGirl.create(:post_comment_1, :post=>post, :user=>user1)}
    let (:post_comment_2) {FactoryGirl.create(:post_comment_2, :post=>post, :user=>user2)}
    let (:post_comment_3) {FactoryGirl.create(:post_comment_3, :post=>post, :user=>user3)}

    it "should display hot comments" do
      hot_comment_2nd = post_comment_1
      hot_comment_3rd = post_comment_2
      hot_comment_1st = post_comment_3
      hot_comments = post.hot_comments
      expect(hot_comments[0]["id"]).to eq(hot_comment_1st.id)
      expect(hot_comments[1]["id"]).to eq(hot_comment_2nd.id)
      expect(hot_comments[2]["id"]).to eq(hot_comment_3rd.id)

      expect(post.hottest_comment["id"]).to eq(hot_comment_1st.id)
    end

    it "should sort all comments by create time desc" do
      new_comment_1st = post_comment_3
      new_comment_2nd = post_comment_2
      new_comment_3rd = post_comment_1
      all_comments = post.all_comments
      expect(all_comments[0]["id"]).to eq(new_comment_1st.id)
      expect(all_comments[1]["id"]).to eq(new_comment_2nd.id)
      expect(all_comments[2]["id"]).to eq(new_comment_3rd.id)
    end


    # it "invited mentors' answers should before other users' answers " do
    # end

    # it "multiple invited mentors' answers should sorted by agree scores desc " do
    # end

    # it "should sort answers according to the rules above when there multiple invited answers and normal answers" do
    # end
  end
end
