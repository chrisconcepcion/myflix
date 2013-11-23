class UsersController < ApplicationController
	before_action :require_authentication, only: [:show]

	def new
		@user = User.new
	end

	def new_with_invitation_token
		invitation = Invitation.find_by(invitation_token: params[:invitation_token])
		if invitation
			@user = User.new(email: invitation.recipient_email)
			@invitation_token = invitation.invitation_token
			render :new
		else
			redirect_to invalid_token_path
		end
	end

	def create
		@user = User.create(user_params)
		if @user.save
			handle_invitation if params[:invitation_token].present?
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

	def handle_invitation
		invitation = Invitation.find_by(invitation_token: params[:invitation_token])
		inviter = invitation.user
		@user.following_relationships.create(leader: inviter)
		inviter.following_relationships.create(leader: @user)
		invitation.update_column(:invitation_token, nil)
	end
end