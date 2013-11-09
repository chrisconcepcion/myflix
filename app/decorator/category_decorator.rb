class CategoryDecorator < Draper::Decorator
	delegate_all
	
	def recent_videos
		self.videos.order('created_at DESC').limit(6).all
	end

end