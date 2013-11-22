require 'spec_helper'

describe PasswordResetsController do
	describe "GET new" do
		it_behaves_like "when token doesn't match a user token" do
			let(:action) { get :new, token: "invalid token" }
		end
	end
	
	describe "POST create" do
		it_behaves_like "when token doesn't match a user token" do
			let(:action) { post :create, token: "invalid token" }
		end

		context "when token matches a user token" do
			context "when new password is valid" do
				it "updates password" do
					user = Fabricate(:user)
					post :create, token: user.token, password: "new_password"
					expect(user.reload.authenticate("new_password")).to be_true
				end

				it "creates the user token" do
					user = Fabricate(:user)
					old_token = user.token
					post :create, token: user.token, password: "new_password"
					expect(user.reload.token).to_not eq old_token
				end
				it "displays flash notice" do
					user = Fabricate(:user)
					old_token = user.token
					post :create, token: user.token, password: "new_password"
					expect(flash[:notice]).to eq "Sign in with your new credentials"
				end
				it "redirects to sign in page" do
					user = Fabricate(:user)
					post :create, token: user.token, password: "new_password"
					expect(response).to redirect_to sign_in_path
				end
			end

			context "when new password is invalid" do
				it "displays a flash error" do
					user = Fabricate(:user)
					post :create, token: user.token, password: "short"
					expect(flash[:error]).to eq "Password is too short (minimum is 6 characters)"
				end
				it "renders to password reset page" do
					user = Fabricate(:user)
					post :create, token: user.token, password: "short"
					expect(response).to render_template :new
				end
			end
		end
	end
end