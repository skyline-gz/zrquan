class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.references :city, index: true
      t.references :industry, index: true
      t.references :corporate_group, index: true
      t.string :address
      t.string :site
      t.string :contact
      t.string :legal_person
      t.integer :capital_state
      t.text :description

      t.timestamps
    end
  end
end
