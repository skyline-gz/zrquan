class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.string :name, limit: 30
      t.text :description
      t.references :parent_industry, index: true

      t.timestamps
    end
  end
end
