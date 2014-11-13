class CreatePersonalSalaries < ActiveRecord::Migration
  def change
    create_table :personal_salaries do |t|
      t.references :user, index: true
      t.references :company, index: true
      t.string :position
      t.integer :salary

      t.timestamps
    end
  end
end
