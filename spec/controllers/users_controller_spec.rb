require 'spec_helper'

describe UsersController do
	describe "GET new" do
		it "sets user variable" do
			get :new
			expect(assigns(:user)).to be_new_record
			expect(assigns(:user)).to be_instance_of(User)
		end
	end

	describe "GET new_with_invitation_token" do
		context "with valid invitation token" do
			it "sets user variable to new record" do
				user = Fabricate(:user)
				invitation = Fabricate(:invitation, user_id: user.id)
				get :new_with_invitation_token, invitation_token: invitation.token
				expect(assigns(:user).email).to eq invitation.recipient_email
			end

			it "sets invitation token variable" do
				user = Fabricate(:user)
				invitation = Fabricate(:invitation, user_id: user.id)
				get :new_with_invitation_token, invitation_token: invitation.token
				expect(assigns(:invitation_token)).to eq invitation.token
			end

			it "renders new user page" do
				user = Fabricate(:user)
				invitation = Fabricate(:invitation, user_id: user.id)
				get :new_with_invitation_token, invitation_token: invitation.token
				expect(response).to render_template :new
			end
		end

		context "with invalid invitation token" do
			it "redirects to invalid token page" do
				get :new_with_invitation_token, invitation_token: "invalid token"
				expect(response).to redirect_to invalid_token_path 
			end
		end
	end

	describe "POST create" do
		context "when signup is successful" do
			it "displays a flash success message" do
				signup = double(:sign_up_results, successful?: true)
				SignUp.any_instance.should_receive(:sign_up).and_return(signup)
				post :create, user: Fabricate.attributes_for(:user)
				expect(flash[:success]).to eq "You are successfully registered, please sign in."
			end
			
			it "redirects to sign in" do
				signup = double(:sign_up_results, successful?: true)
				SignUp.any_instance.should_receive(:sign_up).and_return(signup)
				post :create, user: Fabricate.attributes_for(:user)
				expect(response).to redirect_to sign_in_path
			end
		end
		context "when signup is unsuccessful" do
			it "renders a template" do
				signup = double(:sign_up_results, successful?: false, error_message: "This is an error message")
				SignUp.any_instance.should_receive(:sign_up).and_return(signup)
				post :create, user: Fabricate.attributes_for(:user)
				expect(response).to render_template :new
			end	

			it "displays a flash error message" do
				signup = double(:sign_up_results, successful?: false, error_message: "This is an error message")
				SignUp.any_instance.should_receive(:sign_up).and_return(signup)
				post :create, user: Fabricate.attributes_for(:user)
			end
		end
	end

	describe "GET show" do
		let(:user) { Fabricate(:user) }

		context "when authenticated" do
			before { set_current_user }

			it "sets user variable" do
				get :show, id: current_user.id
				expect(assigns(:user)).to eq current_user
			end

			it "decorators user variable" do
				get :show, id: current_user.id
				expect(assigns(:user)).to be_decorated_with UserDecorator
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :show, id: user.id }
		end
	end
end