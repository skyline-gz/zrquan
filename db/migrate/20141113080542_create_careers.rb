class CreateCareers < ActiveRecord::Migration
  def change
    create_table :careers do |t|
      t.references :user, index: true
      t.references :company, index: true
      t.string :position, limit: 30
      t.string :entry_year, limit: 8
      t.string :leave_year, limit: 8
      t.text :description

      t.timestamps
    end
  end
end
