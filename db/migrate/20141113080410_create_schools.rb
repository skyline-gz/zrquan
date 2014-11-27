class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.references :location, index: true
      t.string :address
      t.string :site
      t.text :description

      t.timestamps
    end

    add_index :schools, :name, unique: true
  end
end
