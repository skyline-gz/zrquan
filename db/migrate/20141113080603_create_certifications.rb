class CreateCertifications < ActiveRecord::Migration
  def change
    create_table :certifications do |t|
      t.string :name
      t.integer :study_time_sum
      t.integer :study_time_samples
      t.integer :study_time_avg
      t.integer :study_cost_sum
      t.integer :study_cost_samples
      t.integer :study_cost_avg
      t.text :regist_rule
      t.text :description

      t.timestamps
    end

    add_index :certifications, :name, unique: true
  end
end
