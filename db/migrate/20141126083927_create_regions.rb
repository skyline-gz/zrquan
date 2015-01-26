class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name, limit: 30

      t.timestamps
    end
  end
end
