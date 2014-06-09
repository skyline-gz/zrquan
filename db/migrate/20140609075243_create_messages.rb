class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :msg_type
      t.references :user, index: true

      t.timestamps
    end
  end
end
