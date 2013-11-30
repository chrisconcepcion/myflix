class SignUp

	attr_reader :error_message

	def initialize(user)
		@user = user
	end

	def sign_up(token, invitation_token)
		if @user.valid?
			charge = StripeWrapper::Customer.create(plan: 'myflix', email: @user.email, card: token)
			if charge.successful?
  				@user.save
					handle_invitation(invitation_token) if invitation_token.present?
					UserMailer.delay.welcome_email(@user)
					@status = :success
					self
			else
				@error_message = charge.error_message
				@status = :failed
				self
			end
		else
			@error_message = "User sign up information is invalid."
			@status = :failed
			self
		end
	end

	def successful?
		@status == :success
	end

	def error_message
		@error_message
	end

private
	def handle_invitation(invitation_token)
		invitation = Invitation.find_by(token: invitation_token)
		inviter = invitation.user
		@user.following_relationships.create(leader: inviter)
		inviter.following_relationships.create(leader: @user)
		invitation.update_column(:token, nil)
	end
end