class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :skills, :name, unique: true
  end
end
