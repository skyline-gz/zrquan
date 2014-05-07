class CreateExperienceArticles < ActiveRecord::Migration
  def change
    create_table :experience_articles do |t|
      t.string :title
      t.text :content
      t.integer :agree_score
      t.references :theme, index: true
      t.references :industry, index: true
      t.references :category, index: true
      t.boolean :mark_flag
      t.references :user, index: true

      t.timestamps
    end
  end
end
