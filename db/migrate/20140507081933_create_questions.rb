class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :content
      t.references :theme, index: true, null: false
      t.references :industry, index: true
      t.references :category, index: true
      t.integer :answer_num
      t.boolean :mark_flag
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
