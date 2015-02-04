class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :token_id
      t.text :content
      t.integer :weight
      t.float :epoch_time, limit: 53
      t.float :hot, limit: 53
      t.integer :agree_score, default: 0
      t.integer :oppose_score, default: 0
      t.integer :actual_score, default: 0
      t.integer :comment_count, default: 0
      t.integer :comment_agree, default: 0
      t.boolean :anonymous_flag, default: false
      t.references :user  # 不设index,用下面的组合索引代替
      t.integer :publish_date
      t.timestamp :edited_at

      t.timestamps
    end

    #add_index :posts, [:user_id, :publish_date]
    add_index :posts, [:user_id, :anonymous_flag]
    add_index :posts, [:user_id, :created_at]

  end
end
