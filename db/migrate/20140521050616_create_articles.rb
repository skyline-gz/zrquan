class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
			t.boolean :draft_flag, default: false
      t.integer :agree_score, default: 0
      t.references :theme, index: true
      t.references :industry, index: true
      t.references :category, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
