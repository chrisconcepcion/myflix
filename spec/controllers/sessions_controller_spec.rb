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
		context "when authentication returns true" do
			let(:user) { Fabricate(:user) }
			let(:authentication) { double(:authentication_results, successful?: true) }
			before { UserAuthentication.any_instance.should_receive(:authenticate).and_return(authentication) }

			it "signs in a user" do
				post :create, email: user.email, password: user.password
				expect(session[:user_id]).to eq user.id
			end

			it "redirects to home" do
				post :create, email: user.email, password: user.password
				expect(response).to redirect_to home_path
			end

			it "displays a flash notice" do
				post :create, email: user.email, password: user.password
				expect(flash[:notice]).to eq "You have logged in successfully."
			end
		end
		

		context "when authentication returns false" do
			let(:authentication) { double(:authentication_results, successful?: false, error_message: "This is an error message") }
			before { UserAuthentication.any_instance.should_receive(:authenticate).and_return(authentication) }
			it "displays flash notice" do
				post :create, email: "", password: ""
				expect(flash[:error]).to eq "This is an error message"
			end

			it "renders new template" do
				post :create, email: "", password: ""
				expect(response).to redirect_to sign_in_path
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