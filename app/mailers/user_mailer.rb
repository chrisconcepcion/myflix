class UserMailer < ActionMailer::Base
	default from: "info@myflix.com"

	def welcome_email(user)
		@user = user
		mail(to: @user.email, subject: "Welcome to MyFlix!")
	end

	def reset_password(user)
		@user = user
		mail(to: @user.email, subject: "Reset your MyFlix password")
	end

	def invitation(user, invitation) 
		@user = user
		@invitation = invitation
		mail(to: @invitation.recipient_email, subject: "#{@user.full_name} has invited you to join MyFLix")
	end

	def locked_account(user)
		@user = user
		mail(to: @user.email, subject: "Your MyFLix account has been locked.")
	end
end