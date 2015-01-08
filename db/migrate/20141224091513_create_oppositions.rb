class CreateOppositions < ActiveRecord::Migration
  def change
    create_table :oppositions do |t|
      t.references :user, index: true
      t.references :opposable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
