class CreateRecommendUsers < ActiveRecord::Migration
  def change
    create_table :recommend_users do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
