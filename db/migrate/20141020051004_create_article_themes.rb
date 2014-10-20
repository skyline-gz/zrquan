class CreateArticleThemes < ActiveRecord::Migration
  def change
    create_table :article_themes do |t|
      t.references :article, index: true
      t.references :theme, index: true

      t.timestamps
    end
  end
end
