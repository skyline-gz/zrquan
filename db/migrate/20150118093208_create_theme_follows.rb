class CreateThemeFollows < ActiveRecord::Migration
  def change
    create_table :theme_follows do |t|
      t.references :theme, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
