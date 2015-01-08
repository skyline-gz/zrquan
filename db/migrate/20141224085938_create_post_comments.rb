class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.text :content
      t.integer :agree_score, default: 0
      t.integer :oppose_score, default: 0
      t.boolean :anonymous_flag, default: false
      t.references :user, index: true
      t.references :replied_comment, index: true

      t.timestamps
    end
  end
end
