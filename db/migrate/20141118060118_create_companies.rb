class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, limit: 30
      t.references :location, index: true
      t.references :industry, index: true
      t.references :parent_company, index: true
      t.string :address, limit: 100
      t.string :site, limit: 30
      t.string :contact, limit: 20
      t.string :legal_person, limit: 30
      t.integer :capital_state
      t.text :description

      t.timestamps
    end

    add_index :companies, :name, unique: true
  end
end
