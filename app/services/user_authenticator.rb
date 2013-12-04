class UserAuthentication

	attr_reader :error_message
	def initialize(user)
		@user = user
	end
		
	def authenticate(password)
		if @user && @user.authenticate(password)
			if @user.active
				@status = :success
				self
			else 
				@error_message = "Your account is locked, please contact customer service to resolve the issue."
				@status = :failed
				self
			end
		else
			@error_message = "Incorrect email or password. Please try again."
			@status = :failed
			self
		end
	end

	def error_message
		@error_message
	end

	def successful?
		@status == :success
	end
end