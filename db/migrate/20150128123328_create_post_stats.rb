class CreatePostStats < ActiveRecord::Migration
  def change
    create_table :post_stats do |t|
      t.integer :post_count
      t.references :theme, index: true
      t.integer :recent_days
    end
  end
end
