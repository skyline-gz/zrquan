class CreateJobCategories < ActiveRecord::Migration
  def change
    create_table :job_categories do |t|
      t.string :name, limit: 30
      t.text :description

      t.timestamps
    end
  end
end
