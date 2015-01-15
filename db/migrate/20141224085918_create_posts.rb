class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :token_id
      t.text :content
      t.integer :hot_abs
      t.integer :agree_score, default: 0
      t.integer :oppose_score, default: 0
      t.boolean :anonymous_flag, default: false
      t.references :user, index: true
      t.timestamp :edited_at

      t.timestamps
    end
  end
end
