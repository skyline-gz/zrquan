class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :content
      t.references :wiki, polymorphic: true, index: true

      t.timestamps
    end
  end
end
