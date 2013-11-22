class ForgotPasswordsController < ApplicationController

	def create
		user = User.find_by(email: params[:email])
		if user
			UserMailer.reset_password(user).deliver
			redirect_to confirm_password_reset_path
		else
			flash[:error] = "This user doesn't exist"
			redirect_to forgot_password_path
		end
	end
end