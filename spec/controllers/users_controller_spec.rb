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

			context "email sending" do
				it "sends out an email" do
					post :create, user: Fabricate.attributes_for(:user)
					expect(ActionMailer::Base.deliveries).to_not be_empty
				end

				it "sends it to the new user" do
					post :create, user: Fabricate.attributes_for(:user)
					expect(ActionMailer::Base.deliveries.last.to).to eq [User.first.email]
				end

				it "has the right content" do
					post :create, user: Fabricate.attributes_for(:user)
					expect(ActionMailer::Base.deliveries.last.body).to include("your username is: #{User.first.email}")
				end
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
				post :create, user: Fabricate.attributes_for(:invalid_user)
				expect(response).to render_template :new
			end

			it "does not create a user" do
				post :create, user: Fabricate.attributes_for(:invalid_user)
				expect(User.count).to eq 0
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