class CreateQuestionStats < ActiveRecord::Migration
  def change
    create_table :question_stats do |t|
      t.integer :question_count
      t.references :theme, index: true
      t.integer :recent_days
    end
  end

end
