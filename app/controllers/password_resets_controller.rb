class PasswordResetsController < ApplicationController
	before_action :require_valid_token, only: [:new, :create]

	def create
		user = User.find_by(token: params[:token])
		user.update_attributes(password: params[:password])
		if user.save
			user.generate_new_token
			flash[:notice] = "Sign in with your new credentials"
			redirect_to sign_in_path
		else
			flash[:error] = "Password is too short (minimum is 6 characters)"
			render :new
		end
	end

private
	def require_valid_token
		redirect_to invalid_token_path unless User.find_by(token: params[:token])
	end
end