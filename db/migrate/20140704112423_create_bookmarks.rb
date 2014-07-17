class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :user, index: true
      t.references :bookmarkable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
