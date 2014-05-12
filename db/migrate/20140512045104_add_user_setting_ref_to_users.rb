class AddUserSettingRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :user_setting, index: true
  end
end
