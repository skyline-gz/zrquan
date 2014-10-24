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

  context "mentor" do
    let (:mentor) { FactoryGirl.create(:mentor_1) }
    let (:normal_user) { FactoryGirl.create(:normal_user_1) }
    let (:question) { FactoryGirl.create(:question_1, :user=>normal_user) }
    let (:published_article) { FactoryGirl.create(:published_article, :user=>normal_user) }
    let (:draft_article) { FactoryGirl.create(:draft_article, :user=>normal_user) }
    let (:mentor_user_setting) { FactoryGirl.create(:user_setting, :user=>mentor) }
    let (:normal_user_setting) { FactoryGirl.create(:user_setting, :user=>normal_user) }
    let (:ability) { Ability.new(mentor) }

    it { should_not be_able_to(:create, Question) }
    it { should_not be_able_to(:create, ConsultSubject) }
    it { should_not be_able_to(:edit, Question) }
    it { should_not be_able_to(:edit, ConsultSubject) }

    context "answer" do
      it { should be_able_to(:answer, question) }
      it {
        my_answer = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>mentor)
        should be_able_to(:edit, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        should_not be_able_to(:edit, other_answer)
      }
      it {
        FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>mentor)
        should_not be_able_to(:answer, question)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        should be_able_to(:agree, other_answer)
      }
      it {
        my_answer = FactoryGirl.create(:q1_invited_answer_1, :question=>question, :user=>mentor)
        should_not be_able_to(:agree, my_answer)
      }
      it {
        other_answer = FactoryGirl.create(:q1_other_answer_1, :question=>question, :user=>normal_user)
        FactoryGirl.create(:answer_agree, :user=>mentor, :agreeable=>other_answer)
        should_not be_able_to(:agree, agreed_answer = other_answer)
      }
    end

    context "article" do
      it { should be_able_to(:create, Article) }
      it {
        my_draft_article = FactoryGirl.create(:draft_article, :user=>mentor)
        should be_able_to(:destroy, my_draft_article)
      }
      it {
        my_published_article = FactoryGirl.create(:published_article, :user=>mentor)
        should_not be_able_to(:destroy, my_published_article)
      }
      it {
        my_draft_article = FactoryGirl.create(:draft_article, :user=>mentor)
        should be_able_to(:edit, my_draft_article)
      }
      it {
        my_published_article = FactoryGirl.create(:published_article, :user=>mentor)
        should be_able_to(:edit, my_published_article)
      }
      it { should_not be_able_to(:edit, published_article) }
      it { should be_able_to(:agree, published_article) }
      it { should_not be_able_to(:agree, draft_article) }
      it {
        my_article = FactoryGirl.create(:published_article, :user=>mentor)
        should_not be_able_to(:agree, my_article)
      }
      it {
        FactoryGirl.create(:answer_agree, :user=>mentor, :agreeable=>published_article)
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
        FactoryGirl.create(:question_bookmark, :user=>mentor, :bookmarkable=>question)
        should_not be_able_to(:bookmark, question)
      }
      it { should be_able_to(:bookmark, published_article) }
      it { should_not be_able_to(:bookmark, draft_article) }
      it {
        FactoryGirl.create(:article_bookmark, :user=>mentor, :bookmarkable=>published_article)
        should_not be_able_to(:bookmark, published_article)
      }
    end

    context "consult" do
      let (:applying_subject) { FactoryGirl.create(:applying_subject, :apprentice=>normal_user, :mentor=>mentor) }
      let (:in_progress_subject) { FactoryGirl.create(:in_progress_subject, :apprentice=>normal_user, :mentor=>mentor) }
      let (:closed_subject) { FactoryGirl.create(:closed_subject, :apprentice=>normal_user, :mentor=>mentor) }
      let (:ignored_subject) { FactoryGirl.create(:ignored_subject, :apprentice=>normal_user, :mentor=>mentor) }
      let (:my_reply) { FactoryGirl.create(:consult_reply, :user=>mentor, :consult_subject=>in_progress_subject) }
      let (:not_my_reply) { FactoryGirl.create(:consult_reply, :user=>normal_user, :consult_subject=>in_progress_subject) }
      let (:other_mentor) { FactoryGirl.create(:mentor_2) }

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
      it { should_not be_able_to(:follow, myself = mentor) }
    end

    context "user info and user setting" do
      it { should be_able_to(:edit, mentor) }
      it { should_not be_able_to(:edit, normal_user) }
      it { should be_able_to(:edit, mentor_user_setting) }
      it { should_not be_able_to(:edit, normal_user_setting) }
    end

  end

  context "normal_user" do

  end
end
