class CreateWelfares < ActiveRecord::Migration
  def change
    create_table :welfares do |t|
      t.string :content
      t.references :company, index: true

      t.timestamps
    end
  end
end
