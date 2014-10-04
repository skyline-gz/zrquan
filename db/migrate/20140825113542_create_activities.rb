class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true
      t.references :target, polymorphic: true, index: true
      t.integer :activity_type
      t.string :title
      t.text :content
      t.integer :agree_score
      t.integer :publish_date, index: true
      t.references :theme, index: true
      t.boolean :recent_flag, default: true

      t.timestamps
    end
  end
end
