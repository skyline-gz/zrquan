class CreateThemeFollows < ActiveRecord::Migration
  def change
    create_table :theme_follows do |t|
      t.references :theme, index: true
      t.references :user

      t.timestamps
    end

    add_index :theme_follows, [:user_id, :created_at]
  end
end
