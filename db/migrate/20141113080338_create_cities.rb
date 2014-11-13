class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.text :expense
      t.text :strong_industry
      t.text :entry_policy
      t.text :support_policy
      t.text :description

      t.timestamps
    end
  end
end
