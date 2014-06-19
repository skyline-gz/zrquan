class CreateConsultSubjects < ActiveRecord::Migration
  def change
    create_table :consult_subjects do |t|
      t.string :title
      t.text :content
      t.references :theme, index: true
      t.references :mentor, index: true
      t.references :apprentice, index: true
      t.integer :stat_class

      t.timestamps
    end
  end
end
