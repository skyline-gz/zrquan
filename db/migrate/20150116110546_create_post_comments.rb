class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.text :content
      t.integer :agree_score
      t.integer :oppose_score
      t.boolean :anonymous_flag
      t.references :post, index: true
      t.references :user, index: true
      t.references :replied_comment, index: true

      t.timestamps
    end
  end
end
