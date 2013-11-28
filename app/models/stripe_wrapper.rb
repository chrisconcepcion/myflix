module StripeWrapper
	def self.set_api_key
		Stripe.api_key = ENV['STRIPE_SECRET_KEY']	
	end

	class Charge
		attr_reader :response, :status 
		def initialize(status, response)
			@status = status
			@response = response
		end

		def self.create(options={})
			StripeWrapper.set_api_key
			begin
				response = Stripe::Charge.create(amount: options[:amount], currency: 'usd', card: options[:card])
				new(:success, response)
			rescue Stripe::CardError => e
				new(:error, e)
			end
		end

		def successful?
			status == :success
		end

		def error_message
			response.message
		end
	end
end