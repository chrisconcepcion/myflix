class UserDecorator < Draper::Decorator
	delegate_all

	def total_queue_items
		queue_items.count
	end

	def queued_video_title(queue_item)
		queue_items.find_by(id: queue_item.id).video.title
	end

	def queued_video_category_name(queue_item)
		queued_video = queue_items.find_by(id: queue_item.id).video
		queued_video.category.name if queued_video.category
	end

	def queued_video_category(queue_item)
		queued_video = queue_items.find_by(id: queue_item.id).video
		queued_video.category if queued_video.category
	end
	
	def reviewed_video_title(review)
		reviews.find_by(id: review.id).video.title
	end

	def total_reviews
		reviews.count
	end


end