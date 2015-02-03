require 'rails_helper'

RSpec.describe User, :type => :model do
  context "password format" do
    context "creates user" do
      it do
        pw = "12345678 "
        expect(User.password_validate?(pw)).to eq(false)
        # expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = " 12345678"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "_12345678"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "12345678_"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "1234 5678"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "1234*5678"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "123as5678)"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "&123as5678"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "&*&)()~!"
        expect(User.password_validate?(pw)).to eq(false)
      end

      it do
        pw = "12345678"
        expect(User.password_validate?(pw)).to eq(true)
      end

      it do
        pw = "abcdefgh"
        expect(User.password_validate?(pw)).to eq(true)
      end

      it do
        pw = "1234eraew"
        expect(User.password_validate?(pw)).to eq(true)
      end

      it do
        pw = "aser1235"
        expect(User.password_validate?(pw)).to eq(true)
      end

      it do
        pw = "aser1235er"
        expect(User.password_validate?(pw)).to eq(true)
      end
    end
  end

  context "name" do
    it "should be error if name mix by alphabet and chinese character" do
      user = FactoryGirl.build(:user_1, :name=>"Johnson李")
      expect{user.save}.to change{user.errors[:first_name].size}.from(0).to(1)
    end

    it "should successfully create user if name has 30 characters when inputs alphabet" do
      user = FactoryGirl.build(:user_1, :name=>"abcdefghijklmnopqrstiherdgwqac")
      expect(user.save).to eq(true)
    end

    it "should be error if name over 10 characters when inputs chinese" do
      user = FactoryGirl.build(:user_1, :name=>"超过十个中文字的名字呀")
      expect{user.save}.to change{user.errors[:last_name].size}.from(0).to(1)
    end
  end

  context "reputation" do
    let (:user1) {FactoryGirl.create(:user_1)}
    let (:user2) {FactoryGirl.create(:user_2)}
    let (:hq) {FactoryGirl.create(:hottest_question, :user=>user2)}
    let (:rq) {FactoryGirl.create(:real_name_question, :user=>user2)}

    it "should ignore anonymous answers' score" do
      FactoryGirl.create(:hq_real_name_answer, :question=>hq, :user=>user1)
      FactoryGirl.create(:hq_anonymous_answer, :question=>hq, :user=>user1)
      FactoryGirl.create(:rq_anonymous_answer, :question=>rq, :user=>user1)
      expect(user1.answer_ag).to eq(80)
      expect(user1.answer_op).to eq(29)
    end

    it "should ignore anonymous posts' score" do
      FactoryGirl.create(:post_1, :user=>user1)
      FactoryGirl.create(:post_4, :user=>user1)
      FactoryGirl.create(:post_5, :user=>user1)
      expect(user1.post_ag).to eq(27)
      expect(user1.post_op).to eq(7)
    end

    it "should ignore anonymous post comments' score" do
      post1 = FactoryGirl.create(:post_1, :user=>user1)
      FactoryGirl.create(:post_comment_1, :post=>post1, :user=>user1)
      FactoryGirl.create(:post_comment_4, :post=>post1, :user=>user1)
      FactoryGirl.create(:post_comment_5, :post=>post1, :user=>user1)
      expect(user1.post_comment_ag).to eq(78)
      expect(user1.post_comment_op).to eq(19)
    end

    it "should calculate reputation correctly" do
      FactoryGirl.create(:hq_real_name_answer, :question=>hq, :user=>user1)
      FactoryGirl.create(:hq_anonymous_answer, :question=>hq, :user=>user1)
      FactoryGirl.create(:rq_anonymous_answer, :question=>rq, :user=>user1)
      post1 = FactoryGirl.create(:post_1, :user=>user1)
      FactoryGirl.create(:post_4, :user=>user1)
      FactoryGirl.create(:post_5, :user=>user1)
      FactoryGirl.create(:post_comment_1, :post=>post1, :user=>user1)
      FactoryGirl.create(:post_comment_4, :post=>post1, :user=>user1)
      FactoryGirl.create(:post_comment_5, :post=>post1, :user=>user1)
      expect(user1.reputation).to eq(475)
    end

  end

end
