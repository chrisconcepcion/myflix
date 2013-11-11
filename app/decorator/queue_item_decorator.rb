class QueueItemDecorator < Draper::Decorator 
	delegate_all

	def video_title
		self.video.title
	end

	def video_genre
		self.video.category.name
	end
end