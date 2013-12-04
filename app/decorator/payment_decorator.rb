class PaymentDecorator < Draper::Decorator
	delegate_all

	def user_full_name
		user.full_name if user
	end

	def formatted_amount
		"$" + (p '%.2f' % (amount/100.0)) 
	end

	def user_email
		user.email if user
	end
end