class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true
      t.references :target, polymorphic: true, index: true
      t.integer :activity_type
      t.integer :publish_date, index: true

      t.timestamps
    end
  end
end
