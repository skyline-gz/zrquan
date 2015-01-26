class CreateOtherWikis < ActiveRecord::Migration
  def change
    create_table :other_wikis do |t|
      t.string :name, limit: 30
      t.text :description

      t.timestamps
    end

    add_index :other_wikis, :name, unique: true
  end
end
