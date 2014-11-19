require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, :type => :model do
  subject { ability }

  context "unconfirmed user" do
    let (:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }
    let (:ability) { Ability.new(unconfirmed_user) }

    it { should_not be_able_to(:create, Question) }
    it { should_not be_able_to(:create, Answer) }
    it { should_not be_able_to(:create, Comment) }
    it { should_not be_able_to(:create, PrivateMessage) }
    it { should_not be_able_to(:create, ConsultSubject) }
    it { should_not be_able_to(:create, ConsultReply) }
    it { should_not be_able_to(:create, Relationship) }
  end

  context "verified user" do
    let (:normal_user) { FactoryGirl.create(:normal_user_1) }
    let (:me) { FactoryGirl.create(:mentor_1) }
    let (:question) { FactoryGirl.create(:question_1, :user=>normal_user) }
    let (:my_question) { FactoryGirl.create(:question_1, :user=>me) }
    let (:published_article) { FactoryGirl.create(:published_article, :user=>normal_user) }
    let (:draft_article) { FactoryGirl.create(:draft_article, :user=>normal_user) }
    let (:my_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>me) }
    let (:another_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>normal_user) }
    let (:ability) { Ability.new(me) }

    context "question" do
      it { should be_able_to(:create, Question) }
      it { should be_able_to(:edit, my_question) }
    end

    context "answer" do
      it { should be_able_to(:answer, question) }
      it {
        my_answer = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>me)
        should be_able_to(:edit, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        should_not be_able_to(:edit, other_answer)
      }
      it {
        FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:answer, answered_question = question)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        should be_able_to(:agree, other_answer)
      }
      it {
        my_answer = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:agree, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        FactoryGirl.create(:answer_agree, :user=>me, :agreeable=>other_answer)
        should_not be_able_to(:agree, agreed_answer = other_answer)
      }
    end

    context "article" do
      it { should be_able_to(:create, Article) }
      it {
        my_draft_article = FactoryGirl.create(:draft_article, :user=>me)
        should be_able_to(:destroy, my_draft_article)
      }
      it {
        my_published_article = FactoryGirl.create(:published_article, :user=>me)
        should_not be_able_to(:destroy, my_published_article)
      }
      it {
        my_draft_article = FactoryGirl.create(:draft_article, :user=>me)
        should be_able_to(:edit, my_draft_article)
      }
      it {
        my_published_article = FactoryGirl.create(:published_article, :user=>me)
        should be_able_to(:edit, my_published_article)
      }
      it { should_not be_able_to(:edit, published_article) }
      it { should be_able_to(:agree, published_article) }
      it { should_not be_able_to(:agree, draft_article) }
      it {
        my_article = FactoryGirl.create(:published_article, :user=>me)
        should_not be_able_to(:agree, my_article)
      }
      it {
        FactoryGirl.create(:article_agree, :user=>me, :agreeable=>published_article)
        should_not be_able_to(:agree, agreed_article = published_article)
      }
    end

    context "comment" do
      it { should be_able_to(:comment, Answer) }
      it { should be_able_to(:comment, published_article) }
      it { should_not be_able_to(:comment, draft_article) }
    end

    context "bookmark" do
      it { should be_able_to(:bookmark, question) }
      it {
        FactoryGirl.create(:question_bookmark, :user=>me, :bookmarkable=>question)
        should_not be_able_to(:bookmark, question)
      }
      it { should be_able_to(:bookmark, published_article) }
      it { should_not be_able_to(:bookmark, draft_article) }
      it {
        FactoryGirl.create(:article_bookmark, :user=>me, :bookmarkable=>published_article)
        should_not be_able_to(:bookmark, published_article)
      }
    end

    context "consult" do
      let (:applying_subject) { FactoryGirl.create(:applying_subject, :apprentice=>normal_user, :mentor=>me) }
      let (:in_progress_subject) { FactoryGirl.create(:in_progress_subject, :apprentice=>normal_user, :mentor=>me) }
      let (:closed_subject) { FactoryGirl.create(:closed_subject, :apprentice=>normal_user, :mentor=>me) }
      let (:ignored_subject) { FactoryGirl.create(:ignored_subject, :apprentice=>normal_user, :mentor=>me) }
      let (:my_reply) { FactoryGirl.create(:consult_reply, :user=>me, :consult_subject=>in_progress_subject) }
      let (:not_my_reply) { FactoryGirl.create(:consult_reply, :user=>normal_user, :consult_subject=>in_progress_subject) }
      let (:other_mentor) { FactoryGirl.create(:mentor_2) }

      it { should be_able_to(:create, ConsultSubject) }
      it { should be_able_to(:consult, other_mentor) }
      it { should be_able_to(:accept, applying_subject) }
      it { should be_able_to(:ignore, applying_subject) }
      it { should_not be_able_to(:accept, in_progress_subject) }
      it { should_not be_able_to(:ignore, in_progress_subject) }
      it { should be_able_to(:close, in_progress_subject) }
      it { should_not be_able_to(:close, applying_subject) }
      it { should be_able_to(:show, applying_subject) }
      it {
        not_my_subject = FactoryGirl.create(:applying_subject, :apprentice=>normal_user, :mentor=>other_mentor)
        should_not be_able_to(:show, not_my_subject)
      }
      it { should be_able_to(:reply, in_progress_subject) }
      it { should_not be_able_to(:reply, applying_subject) }
      it { should be_able_to(:edit, my_reply) }
      it { should_not be_able_to(:edit, not_my_reply) }
    end

    context "follow" do
      it { should be_able_to(:follow, other_user = normal_user) }
      it { should_not be_able_to(:follow, myself = me) }
      it {
        FactoryGirl.create(:relationship, :following_user=>normal_user, :follower=>me)
        should be_able_to(:unfollow, following_user = normal_user)
      }
      it { should_not be_able_to(:unfollow, not_following = normal_user) }
    end

    context "pm" do
      it {
        FactoryGirl.create(:relationship, :following_user=>me, :follower=>normal_user)
        should be_able_to(:pm, follower = normal_user)
      }
      it {
        FactoryGirl.create(:private_message, :user1=>normal_user, :user2=>me)
        should be_able_to(:pm, ever_pm_user = normal_user)
      }
      it { should_not be_able_to(:pm, no_relationship_user = normal_user) }
    end

    context "user info and user setting" do
      it { should be_able_to(:edit, me) }
      it { should_not be_able_to(:edit, normal_user) }
      it { should be_able_to(:edit, my_user_msg_setting) }
      it { should_not be_able_to(:edit, another_user_msg_setting) }
    end

  end

  context "normal_user" do
    let (:me) { FactoryGirl.create(:normal_user_2) }
    let (:verified_user) { FactoryGirl.create(:mentor_1) }
    let (:another_n_user) { FactoryGirl.create(:normal_user_1) }
    let (:question) { FactoryGirl.create(:question_1, :user=>another_n_user) }
    let (:my_question) { FactoryGirl.create(:question_1, :user=>me) }
    let (:published_article) { FactoryGirl.create(:published_article, :user=>another_n_user) }
    let (:draft_article) { FactoryGirl.create(:draft_article, :user=>another_n_user) }
    let (:my_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>me) }
    let (:another_user_msg_setting) { FactoryGirl.create(:user_msg_setting, :user=>another_n_user) }
    let (:ability) { Ability.new(me) }

    context "question" do
      it { should be_able_to(:create, Question) }
      it { should be_able_to(:edit, my_question) }
    end

    context "answer" do
      it { should_not be_able_to(:answer, my_question) }
      it { should be_able_to(:answer, not_my_question = question) }
      it {
        my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>me)
        should be_able_to(:edit, my_answer)
      }
      it {
        not_my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>another_n_user)
        should_not be_able_to(:edit, not_my_answer)
      }
      it {
        FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:answer, answered_question = question)
      }
      it {
        not_my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>another_n_user)
        should be_able_to(:agree, not_my_answer)
      }
      it {
        my_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>me)
        should_not be_able_to(:agree, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>another_n_user)
        FactoryGirl.create(:answer_agree, :user=>me, :agreeable=>other_answer)
        should_not be_able_to(:agree, agreed_answer = other_answer)
      }
    end

    context "article" do
      it { should be_able_to(:create, Article) }
      it {
        my_draft_article = FactoryGirl.create(:draft_article, :user=>me)
        should be_able_to(:destroy, my_draft_article)
      }
      it {
        my_published_article = FactoryGirl.create(:published_article, :user=>me)
        should_not be_able_to(:destroy, my_published_article)
      }
      it {
        my_draft_article = FactoryGirl.create(:draft_article, :user=>me)
        should be_able_to(:edit, my_draft_article)
      }
      it {
        my_published_article = FactoryGirl.create(:published_article, :user=>me)
        should be_able_to(:edit, my_published_article)
      }
      it { should_not be_able_to(:edit, published_article) }
      it { should be_able_to(:agree, published_article) }
      it { should_not be_able_to(:agree, draft_article) }
      it {
        my_article = FactoryGirl.create(:published_article, :user=>me)
        should_not be_able_to(:agree, my_article)
      }
      it {
        FactoryGirl.create(:article_agree, :user=>me, :agreeable=>published_article)
        should_not be_able_to(:agree, agreed_article = published_article)
      }
    end

    context "consult" do
      let (:applying_subject) { FactoryGirl.create(:applying_subject, :apprentice=>me, :mentor=>verified_user) }
      let (:in_progress_subject) { FactoryGirl.create(:in_progress_subject, :apprentice=>me, :mentor=>verified_user) }
      let (:my_reply) { FactoryGirl.create(:consult_reply, :user=>me, :consult_subject=>in_progress_subject) }
      let (:not_my_reply) { FactoryGirl.create(:consult_reply, :user=>another_n_user, :consult_subject=>in_progress_subject) }

      it { should be_able_to(:create, ConsultSubject) }
      it { should be_able_to(:consult, verified_user) }
      it { should_not be_able_to(:consult, another_n_user) }
      it { should_not be_able_to(:accept, ConsultSubject) }
      it { should_not be_able_to(:ignore, ConsultSubject) }
      it { should be_able_to(:close, my_subject = in_progress_subject) }
      it { should_not be_able_to(:close, applying_subject) }
      it { should be_able_to(:show, my_applying_subject = applying_subject) }
      it {
        not_my_subject = FactoryGirl.create(:applying_subject, :apprentice=>another_n_user, :mentor=>verified_user)
        should_not be_able_to(:show, not_my_subject)
      }
      it { should be_able_to(:reply, my_subject = in_progress_subject) }
      it { should_not be_able_to(:reply, applying_subject) }
      it { should be_able_to(:edit, my_reply) }
      it { should_not be_able_to(:edit, not_my_reply) }
    end

    context "comment" do
      it { should be_able_to(:comment, Answer) }
      it { should be_able_to(:comment, published_article) }
      it { should_not be_able_to(:comment, draft_article) }
    end

    context "bookmark" do
      it { should be_able_to(:bookmark, question) }
      it {
        FactoryGirl.create(:question_bookmark, :user=>me, :bookmarkable=>question)
        should_not be_able_to(:bookmark, bookmarked_question = question)
      }
      it { should be_able_to(:bookmark, published_article) }
      it { should_not be_able_to(:bookmark, draft_article) }
      it {
        FactoryGirl.create(:article_bookmark, :user=>me, :bookmarkable=>published_article)
        should_not be_able_to(:bookmark, bookmarked_article = published_article)
      }
    end

    context "follow" do
      it { should be_able_to(:follow, other_user = verified_user) }
      it { should_not be_able_to(:follow, myself = me) }
      it {
        FactoryGirl.create(:relationship, :following_user=>verified_user, :follower=>me)
        should be_able_to(:unfollow, following_user = verified_user)
      }
      it { should_not be_able_to(:unfollow, not_following = verified_user) }
    end

    context "pm" do
      it {
        FactoryGirl.create(:relationship, :following_user=>me, :follower=>verified_user)
        should be_able_to(:pm, follower = verified_user)
      }
      it {
        FactoryGirl.create(:private_message, :user1=>me, :user2=>verified_user)
        should be_able_to(:pm, ever_pm_user = verified_user)
      }
      it { should_not be_able_to(:pm, no_relationship_user = verified_user) }
    end

    context "user info and user setting" do
      it { should be_able_to(:edit, me) }
      it { should_not be_able_to(:edit, other_user = verified_user) }
      it { should be_able_to(:edit, my_user_msg_setting) }
      it { should_not be_able_to(:edit, another_user_msg_setting) }
    end

  end
end
