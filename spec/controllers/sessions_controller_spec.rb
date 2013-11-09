require 'spec_helper'

describe SessionsController do
	describe "GET welcome" do
		context "when user is authenticated" do
			it "redirect to home" do
				set_current_user
				get :welcome
				expect(response).to redirect_to home_path
			end
		end
	end

	describe "GET new" do
		context "if user is authenticated" do
			it "redirects to home" do
				set_current_user
				get :new
				expect(response).to redirect_to home_path
			end
		end
	end

	describe "POST create" do
		context "with valid inputs" do
			let(:user) { Fabricate(:user) }
			it "signs in a user" do
				post :create, email: user.email, password: user.password
				expect(session[:user_id]).to eq user.id
			end
			it "redirects to home" do
				post :create, email: user.email, password: user.password
				expect(response).to redirect_to home_path
			end
		end
		context "with invalid input" do
			it "displays flash notice" do
				post :create, email: "", password: ""
				expect(flash[:notice]).to eq "Incorrect email or password. Please try again."
			end
			it "renders new template" do
				post :create, email: "", password: ""
				expect(response).to render_template :new
			end
		end
	end

	describe "DELETE destroy" do
		context "when authenticated" do
			it "logs out a user" do
				set_current_user
				get :destroy
				expect(session[:user_id]).to eq nil
			end
			it "displays a flash notice" do
				set_current_user
				get :destroy
				expect(flash[:notice]).to eq "You have been signed out."
			end
			it "redirects to welcome page" do
				set_current_user
				get :destroy
				expect(response).to redirect_to root_path
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :destroy }
		end
	end
end