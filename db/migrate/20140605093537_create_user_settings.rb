class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.boolean :followed_flag
      t.boolean :aggred_flag
      t.boolean :commented_flag
      t.boolean :answer_flag
      t.boolean :pm_flag

      t.timestamps
    end
  end
end
