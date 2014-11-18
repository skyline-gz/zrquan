class CreateIndustryJobCategories < ActiveRecord::Migration
  def change
    create_table :industry_job_categories do |t|
      t.references :industry, index: true
      t.references :job_category, index: true

      t.timestamps
    end
  end
end
