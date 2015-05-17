class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :user_id
      t.string :timestamp
      t.integer :session_id
      t.text :message
      t.integer :rating

      t.timestamps null: false
    end
  end
end
