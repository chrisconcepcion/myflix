class ReviewDecorator < Draper::Decorator
	delegate_all

	def reviewer_name
		self.user.full_name
	end

end