class UserMailer < ActionMailer::Base
	default from: "change after you get heroku url"

	def welcome_email(user)
		@user = user
		mail(to: @user.email, subject: "Welcome to MyFlix!")
	end

	def reset_password(user)
		@user = user
		mail(to: @user.email, subject: "Reset your MyFlix password")
	end
end