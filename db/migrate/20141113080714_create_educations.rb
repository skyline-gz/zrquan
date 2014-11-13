class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.references :user, index: true
      t.references :school, index: true
      t.string :major
      t.string :graduate_year
      t.text :description

      t.timestamps
    end
  end
end
