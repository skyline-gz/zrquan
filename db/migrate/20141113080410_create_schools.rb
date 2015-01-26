class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name, limit: 30
      t.references :location, index: true
      t.string :address, limit: 100
      t.string :site, limit: 30
      t.text :description

      t.timestamps
    end

    add_index :schools, :name, unique: true
  end
end
