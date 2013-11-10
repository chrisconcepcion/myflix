class VideoDecorator < Draper::Decorator
	delegate_all

	def average_rating
		'%.2f' %(self.reviews.average('rating')) unless self.reviews.empty? 
	end
end