class CreateConsultReplies < ActiveRecord::Migration
  def change
    create_table :consult_replies do |t|
      t.references :consult_subject, index: true
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
