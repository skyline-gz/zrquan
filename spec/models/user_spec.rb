require 'rails_helper'

RSpec.describe User, :type => :model do
  context "password format" do
    it do
      pw = "12345678 "
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = " 12345678"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "_12345678"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "12345678_"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "1234 5678"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "1234*5678"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "123as5678)"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "&123as5678"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "&*&)()~!"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect{user.save}.to change{user.errors[:password].size}.from(0).to(1)
    end

    it do
      pw = "12345678"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect(user.save).to eq(true)
    end

    it do
      pw = "abcdefgh"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect(user.save).to eq(true)
    end

    it do
      pw = "1234eraew"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect(user.save).to eq(true)
    end

    it do
      pw = "aser1235"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect(user.save).to eq(true)
    end

    it do
      pw = "aser1235er"
      user = FactoryGirl.build(:normal_user_1, :password=>pw, :password_confirmation=>pw)
      expect(user.save).to eq(true)
    end
  end

end
