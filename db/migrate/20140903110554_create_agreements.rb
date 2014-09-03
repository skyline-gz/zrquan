class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.references :user, index: true
      t.references :agreeable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
