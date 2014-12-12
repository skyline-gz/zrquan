class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.references :user, index: true
      t.integer :hot_abs
      t.references :latest_answer, index: true
      t.integer :latest_qa_time, :limit => 8
      t.timestamp :edited_at

      t.timestamps
    end
  end
end
