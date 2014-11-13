class CreateCityFoods < ActiveRecord::Migration
  def change
    create_table :city_foods do |t|
      t.string :content
      t.references :city, index: true

      t.timestamps
    end
  end
end
