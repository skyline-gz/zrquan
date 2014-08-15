class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.references :feedable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
