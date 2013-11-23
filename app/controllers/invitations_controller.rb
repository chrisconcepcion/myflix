class InvitationsController < ApplicationController
	before_action :require_authentication, only: [:new, :create]

	def new
		@invitation = Invitation.new
	end

	def create
		@invitation = current_user.invitations.create(invitation_params)
		if @invitation.save
			UserMailer.invitation(current_user, @invitation).deliver
			flash[:notice] = "Your invitation has been sent."
			redirect_to invite_path
		else
			render :new
		end
	end

private
	def invitation_params
		params.require(:invitation).permit(:user_id, :token, :recipient_name, :recipient_email, :message)
	end
end