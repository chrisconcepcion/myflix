class VideoDecorator < Draper::Decorator
	delegate_all

	def average_rating
		'%.2f' %(self.reviews.average('rating')) unless self.reviews.empty? 
	end

	def queued?(user)
		if user.queue_items.find_by(video_id: self.id)
			true
		else
			false
		end
	end
end