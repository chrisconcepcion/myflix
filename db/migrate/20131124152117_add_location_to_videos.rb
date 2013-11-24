class AddLocationToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :location, :string
  end
end
