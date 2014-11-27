class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.references :location, index: true
      t.references :industry, index: true
      t.references :parent_company, index: true
      t.string :address
      t.string :site
      t.string :contact
      t.string :legal_person
      t.integer :capital_state
      t.text :description

      t.timestamps
    end

    add_index :companies, :name, unique: true
  end
end
