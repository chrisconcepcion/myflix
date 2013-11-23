require 'spec_helper'

describe InvitationsController do
	describe "GET new" do
		context "when user is authenticated" do
			before { set_current_user }
			it "sets invitation variable to be a new invitation " do
				get :new
				expect(assigns(:invitation)).to be_a_new(Invitation)
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :new }
		end
	end

	describe "POST create" do
		context "When user is authenticated" do
			before { set_current_user }
			context "when inputs are valid" do
				it "creates a new invitation" do
					post :create, invitation: Fabricate.attributes_for(:invitation)
					expect(Invitation.count).to eq 1
				end

				it "creates a new invitation associated with a user" do
					post :create, invitation: Fabricate.attributes_for(:invitation)
					expect(current_user.invitations.count).to eq 1
				end

				it "sends an email to invitation receipient" do
					post :create, invitation: Fabricate.attributes_for(:invitation)
					expect(ActionMailer::Base.deliveries.last.to).to eq [Invitation.first.recipient_email]
				end

				it "displays a flash notice" do
					post :create, invitation: Fabricate.attributes_for(:invitation)
					expect(flash[:notice]).to eq "Your invitation has been sent."
				end

				it "redirect_to invite page" do
					post :create, invitation: Fabricate.attributes_for(:invitation)
					expect(response).to redirect_to invite_path
				end
			end

			context "when inputs are invalid" do
				it "doesn't create an invitation" do
					post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
					expect(Invitation.count).to eq 0
				end

				it "renders new template" do
					post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
					expect(response).to render_template :new
				end
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { post :create }
		end
	end
end