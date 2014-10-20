class CreateConsultThemes < ActiveRecord::Migration
  def change
    create_table :consult_themes do |t|
      t.references :consult_subject, index: true
      t.references :theme, index: true

      t.timestamps
    end
  end
end
