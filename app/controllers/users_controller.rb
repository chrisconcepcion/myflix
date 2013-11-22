class UsersController < ApplicationController
	before_action :require_authentication, only: [:show]

	def new
		@user = User.new
	end

	def create
		@user = User.create(user_params)
		if @user.save
			UserMailer.welcome_email(@user).deliver
			flash[:success] = "You are successfully registered, please sign in."
			redirect_to root_path
		else
			render :new
		end
	end

	def show
		@user = UserDecorator.decorate(User.find_by(id: params[:id]))
	end

private
	def user_params
		params.require(:user).permit(:email, :password, :full_name)
	end
end