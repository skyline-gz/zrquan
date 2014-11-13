class CreateCompanySalaries < ActiveRecord::Migration
  def change
    create_table :company_salaries do |t|
      t.references :company, index: true
      t.string :position
      t.integer :salary_sum
      t.integer :samples
      t.integer :salary_avg

      t.timestamps
    end
  end
end
