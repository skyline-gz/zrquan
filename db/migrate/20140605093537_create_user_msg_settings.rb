class CreateUserMsgSettings < ActiveRecord::Migration
  def change
    create_table :user_msg_settings do |t|
      t.boolean :followed_flag, default: true
      t.boolean :agreed_flag, default: true
      t.boolean :commented_flag, default: true
      t.boolean :answer_flag, default: true
      t.boolean :pm_flag, default: true
			t.references :user, index: true

      t.timestamps
    end
  end
end
