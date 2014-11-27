class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.references :substance, polymorphic: true, index: true

      t.timestamps
    end

    add_index :themes, :name, unique: true
  end
end
