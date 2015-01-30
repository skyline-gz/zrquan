class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :user    # 不设index,用下面的组合索引代替
      t.references :bookmarkable, polymorphic: true, index: true

      t.timestamps
    end

    add_index :bookmarks, [:user_id, :created_at]
  end
end
