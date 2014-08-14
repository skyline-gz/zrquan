class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.boolean :followed_flag, default: true
      t.boolean :aggred_flag, default: true
      t.boolean :commented_flag, default: true
      t.boolean :answer_flag, default: true
      t.boolean :pm_flag, default: true
			t.references :user, index: true

      t.timestamps
    end
  end
end
