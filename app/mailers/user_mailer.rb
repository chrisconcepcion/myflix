class UserMailer < ActionMailer::Base
	default from: "change after you get heroku url"

	def welcome_email(user)
		@user = user
		mail(to: @user.email, subject: "Welcome to MyFlix!")
	end
end