class CreateCorporateGroups < ActiveRecord::Migration
  def change
    create_table :corporate_groups do |t|
      t.string :name
      t.references :industry, index: true
      t.string :site
      t.string :legal_person
      t.integer :capital_state
      t.text :description

      t.timestamps
    end
  end
end
