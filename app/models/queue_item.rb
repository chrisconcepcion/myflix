class QueueItem < ActiveRecord::Base
	belongs_to :user
	belongs_to :video

	validates :user_id, presence: true
	validates :video_id, presence: true, uniqueness: { scope: :user_id }
	def create_position
		update_attributes(position: (user.queue_items.count))
	end

	def greatest_position?
		position == user.queue_items.maximum('position')
	end

	def self.reorder_queue(user)
		count = 1
		user.queue_items.order("position ASC").each do |queue_item|
			queue_item.update_attributes(position: count)
			count +=1
		end
	end
end