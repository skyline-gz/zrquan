class CreateConsultSubjects < ActiveRecord::Migration
  def change
    create_table :consult_subjects do |t|
      t.string :title
      t.text :content
      t.references :theme, index: true
      t.references :mentor, index: true
      t.references :apprentice, index: true
      t.integer :mentor_stat_flag
      t.integer :user_stat_flag

      t.timestamps
    end
  end
end
