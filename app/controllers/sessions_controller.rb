class SessionsController < ApplicationController
	before_action :already_authenticated, only: [:welcome, :new]
	before_action :require_authentication, only: [:destroy]

	def welcome
	end

	def new
	end

	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			if user.active
				session[:user_id] = user.id
				flash[:notice] = "You have logged in successfully."
				redirect_to home_path
			else 
				flash[:error] = "Your account is locked, please contact customer service to resolve the issue."
				redirect_to sign_in_path
			end
		else
			flash[:notice] = "Incorrect email or password. Please try again."
			render :new
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "You have been signed out."
		redirect_to root_path
	end
end