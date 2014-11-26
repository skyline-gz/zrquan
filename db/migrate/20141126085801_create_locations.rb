class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.references :region, index: true
      t.text :expense
      t.text :strong_industry
      t.text :entry_policy
      t.text :support_policy
      t.text :description

      t.timestamps
    end
  end
end
