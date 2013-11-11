class QueueItem < ActiveRecord::Base
	belongs_to :user
	belongs_to :video

	validates :user_id, presence: true
	validates :video_id, presence: true, uniqueness: { scope: :user_id }

	def create_position
		user = self.user
		self.update_attributes(position: (user.queue_items.count))
	end
end