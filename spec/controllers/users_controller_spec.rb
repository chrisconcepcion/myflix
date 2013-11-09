require 'spec_helper'

describe UsersController do
	describe "GET new" do
		it "sets user variable" do
			get :new
			expect(assigns(:user)).to be_new_record
			expect(assigns(:user)).to be_instance_of(User)
		end
	end

	describe "POST create" do
		context "with valid input" do
			it "creates a new record" do
				post :create, user: Fabricate.attributes_for(:user) 
				expect(User.count).to eq 1
			end
			it "displays a flash message" do
				post :create, user: Fabricate.attributes_for(:user) 
				expect(flash[:success]).to eq "You are successfully registered, please sign in."
			end
			it "redirects to root" do
				post :create, user: Fabricate.attributes_for(:user) 
				expect(response).to redirect_to root_path
			end
		end
		context "with invalid input" do
			it "renders a template" do
				post :create, user: { email: "" }
				expect(response).to render_template :new
			end

			it "does not create a user" do
				post :create, user: { email: "" }
				expect(User.count).to eq 0
			end
		end
	end
end