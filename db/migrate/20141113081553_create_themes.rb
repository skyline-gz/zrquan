class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name, limit: 30
      t.text :description

      t.timestamps
    end

    add_index :themes, :name, unique: true
  end
end
