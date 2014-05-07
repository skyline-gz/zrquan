class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, index: true
      t.references :commentable, polymorphic: true, index: true
      t.integer :comment_type

      t.timestamps
    end
  end
end
