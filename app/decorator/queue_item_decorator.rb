class QueueItemDecorator < Draper::Decorator 
	delegate_all

	def video_title
		self.video.title
	end

	def video_genre
		self.video.category.name
	end

	def rating
		review = self.video.reviews.find_by(user_id: user.id)
		review.rating if review
	end

	def video_category
		video.category
	end
end