class UsersController < ApplicationController
	before_action :require_authentication, only: [:show]

	def new
		@user = User.new
	end

	def new_with_invitation_token
		invitation = Invitation.find_by(token: params[:invitation_token])
		if invitation
			@user = User.new(email: invitation.recipient_email)
			@invitation_token = invitation.token
			render :new
		else
			redirect_to invalid_token_path
		end
	end

	def create
		@user = User.new(user_params)
		if @user.valid?
			token = params[:stripeToken]
			charge = StripeWrapper::Charge.create(amount: 9990, currency: 'usd', card: token)
			if charge.successful?
  				@user.save
					handle_invitation if params[:invitation_token].present?
					UserMailer.delay.welcome_email(@user)
					flash[:success] = "You are successfully registered, please sign in."
					redirect_to sign_in_path
			else
				flash[:error] = charge.error_message
				render :new
			end
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
		invitation = Invitation.find_by(token: params[:invitation_token])
		inviter = invitation.user
		@user.following_relationships.create(leader: inviter)
		inviter.following_relationships.create(leader: @user)
		invitation.update_column(:token, nil)
	end
end