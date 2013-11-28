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
		let(:valid_credit_card_token) { Stripe::Token.create(card: { number: 4242424242424242, exp_month: 12, exp_year: 2022, cvc: 123}).id }
		let(:invalid_credit_card_token) { Stripe::Token.create(card: { number: 4000000000000002, exp_month: 12, exp_year: 2022, cvc: 123}).id }
		context "with valid input" do
			before do
				charge = double("charge")
				charge.stub(:successful?).and_return(true)
				StripeWrapper::Charge.stub(:create).and_return(charge)
			end

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

				context "when invitation_token is present" do
					it "new user is following inviter" do
						inviter = Fabricate(:user)
						invitation = Fabricate(:invitation, user_id: inviter.id)
						post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
						expect(assigns(:user).following_relationships.first.leader).to eq inviter
					end
					it "inviter is following new user" do
						inviter = Fabricate(:user)
						invitation = Fabricate(:invitation, user_id: inviter.id)
						post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
						expect(inviter.reload.following_relationships.first.leader).to eq assigns(:user)
					end
					it "expires the invitation" do
						inviter = Fabricate(:user)
						invitation = Fabricate(:invitation, user_id: inviter.id)
						post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
						expect(invitation.reload.token).to eq nil
					end
				end
			end

			it "displays a flash message" do
				post :create, user: Fabricate.attributes_for(:user)
				expect(flash[:success]).to eq "You are successfully registered, please sign in."
			end
			
			it "redirects to sign in" do
				post :create, user: Fabricate.attributes_for(:user)
				expect(response).to redirect_to sign_in_path
			end
		end
		context "with invalid input" do
			before do
				charge = double("charge")
				charge.stub(:successful?).and_return(false)
				charge.stub(:error_message).and_return("error_message")
				StripeWrapper::Charge.stub(:create).and_return(charge)
			end
			context "with invalid user field input" do
				it "renders a template" do
					post :create, user: Fabricate.attributes_for(:invalid_user)
					expect(response).to render_template :new
				end	

				it "does not create a user" do
					post :create, user: Fabricate.attributes_for(:invalid_user)
					expect(User.count).to eq 0
				end
			end

			context "with valid user and invalid credit card" do
				it "renders a template" do
					post :create, user: Fabricate.attributes_for(:user)
					expect(response).to render_template :new
				end	

				it "does not create a user" do
					post :create, user: Fabricate.attributes_for(:user)
					expect(User.count).to eq 0
				end

				it "displays a flash error" do
					post :create, user: Fabricate.attributes_for(:user)
					expect(flash[:error]).to_not be_nil
				end
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