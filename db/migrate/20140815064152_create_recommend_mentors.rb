class CreateRecommendMentors < ActiveRecord::Migration
  def change
    create_table :recommend_mentors do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
