class CreatePostThemes < ActiveRecord::Migration
  def change
    create_table :post_themes do |t|
      t.references :post, index: true
      t.integer    :hot
      t.references :theme, index: true

      t.timestamps
    end
  end
end
