class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
    	t.integer :user_id, :video_id, :rating
    	t.text :description
    	t.timestamps
    end
  end
end
