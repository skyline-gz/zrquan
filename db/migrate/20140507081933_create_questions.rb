class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.references :theme, index: true
      t.references :industry, index: true
      t.references :category, index: true
      t.integer :answer_num
      t.boolean :mark_flag
      t.references :user, index: true

      t.timestamps
    end
  end
end
