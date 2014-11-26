class CreateFoodStyles < ActiveRecord::Migration
  def change
    create_table :food_styles do |t|
      t.string :content
      t.references :location, index: true

      t.timestamps
    end
  end
end
