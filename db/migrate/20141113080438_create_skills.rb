class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name, limit: 30
      t.text :description

      t.timestamps
    end

    add_index :skills, :name, unique: true
  end
end
