class CreateCareers < ActiveRecord::Migration
  def change
    create_table :careers do |t|
      t.references :user, index: true
      t.references :industry, index: true
      t.references :company, index: true
      t.string :position
      t.string :entry_year
      t.string :entry_month
      t.string :leave_year
      t.string :leave_month
      t.text :description

      t.timestamps
    end
  end
end
