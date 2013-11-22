require 'spec_helper'

describe ForgotPasswordsController do
	describe "POST create" do
		context "with existing email" do
			it "sends out an email to the email address" do
				user = Fabricate(:user)
				post :create, email: user.email 
				expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
			end

			it "redirects to confirmation page" do
				user = Fabricate(:user)
				post :create, email: user.email
				expect(response).to redirect_to confirm_password_reset_path
			end
		end

		context "when email doesn't exist" do
			it "displays a flash error" do
				post :create, email: "doesn't exist"
				expect(flash[:error]).to eq "This user doesn't exist"
			end
			it "redirects to forgot password page" do
				post :create, email: "doesn't exist"
				expect(response).to redirect_to forgot_password_path
			end
		end
	end
end