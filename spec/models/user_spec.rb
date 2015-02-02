require 'rails_helper'

RSpec.describe User, :type => :model do
  context "password format" do
    context "creates user" do
      it do
        pw = "12345678 "
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = " 12345678"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "_12345678"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "12345678_"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "1234 5678"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "1234*5678"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "123as5678)"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "&123as5678"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "&*&)()~!"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it do
        pw = "12345678"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect(user.save).to eq(true)
      end

      it do
        pw = "abcdefgh"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect(user.save).to eq(true)
      end

      it do
        pw = "1234eraew"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect(user.save).to eq(true)
      end

      it do
        pw = "aser1235"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect(user.save).to eq(true)
      end

      it do
        pw = "aser1235er"
        user = FactoryGirl.build(:user_1, :password=>pw, :password_confirmation=>pw)
        expect(user.save).to eq(true)
      end
    end

    context "updates user" do
      it do
        pw = "12345678 "
        user = FactoryGirl.create(:user_1)
        expect{user.update(password: pw, password_confirmation: pw)}.to change{user.errors[:password].size}.from(0).to(1)
      end

      it "should successfully update user without changing password" do
        user = FactoryGirl.create(:user_1)
        expect(user.update(first_name: "改名")).to eq(true)
      end
    end
  end

  context "last_name & first_name" do
    it "should be error if first_name mix by alphabet and chinese character" do
      user = FactoryGirl.build(:user_1, :first_name=>"Johnson李")
      expect{user.save}.to change{user.errors[:first_name].size}.from(0).to(1)
    end

    it "should be error if last_name over 20 characters when inputs alphabet" do
      user = FactoryGirl.build(:user_1, :last_name=>"abcdefghijklmnopqrstuv")
      expect{user.save}.to change{user.errors[:last_name].size}.from(0).to(1)
    end

    it "should successfully create user if last_name has 20 characters when inputs alphabet" do
      user = FactoryGirl.build(:user_1, :last_name=>"abcdefghijklmnopqrst")
      expect(user.save).to eq(true)
    end

    it "should be error if last_name over 9 characters when inputs chinese" do
      user = FactoryGirl.build(:user_1, :last_name=>"超过九个中文字的名字")
      expect{user.save}.to change{user.errors[:last_name].size}.from(0).to(1)
    end

    it "should successfully create user if last_name has 9 characters when inputs chinese" do
      user = FactoryGirl.build(:user_1, :last_name=>"有九个中文字的名字")
      expect(user.save).to eq(true)
    end
  end

end
