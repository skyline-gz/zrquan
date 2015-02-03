class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.text :content
      t.integer :agree_score
      t.integer :oppose_score
      t.integer :actual_score, default: 0
      t.boolean :anonymous_flag
      t.references :post  # 不设index,用下面的组合索引代替
      t.references :user  # 不设index,用下面的组合索引代替
      t.references :replied_comment, index: true

      t.timestamps
    end

    add_index :post_comments, [:post_id, :actual_score]
    add_index :post_comments, [:post_id, :created_at]
    add_index :post_comments, [:user_id, :anonymous_flag]
  end
end
