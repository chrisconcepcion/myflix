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
			Stripe.api_key = "#{ENV['STRIPE_SECRET_KEY']}"		
			token = params[:stripeToken]
			begin
  			charge = Stripe::Charge.create(
  	  		:amount => 9990, # amount in cents, again
  	  		:currency => "usd",
  	  		:card => token,
   		 		:description => "@user.email MyFLix subscription"
   		 		)
  				@user.save
					handle_invitation if params[:invitation_token].present?
					UserMailer.delay.welcome_email(@user)
					flash[:success] = "You are successfully registered, please sign in."
					redirect_to sign_in_path
			rescue Stripe::CardError => e
				flash[:error] = e.message
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