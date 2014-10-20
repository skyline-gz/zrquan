class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.references :industry, index: true
      t.references :category, index: true
      t.integer :answer_num, default: 0
      t.references :user, index: true

      t.timestamps
    end
  end
end
