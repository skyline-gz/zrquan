class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.references :user, index: true
      t.references :school, index: true
      t.string :major, limit: 30
      t.string :graduate_year, limit: 8
      t.text :description

      t.timestamps
    end
  end
end
