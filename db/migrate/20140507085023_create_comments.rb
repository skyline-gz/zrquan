class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, index: true
      t.boolean :anonymous_flag, default: false
      t.references :commentable, polymorphic: true, index: true
			t.references :replied_comment, index: true

      t.timestamps
    end

    add_index :comments, [:commentable_id, :commentable_type, :created_at], name: "index_comments_on_commentable"
    remove_index :comments, [:commentable_id, :commentable_type]
  end
end
