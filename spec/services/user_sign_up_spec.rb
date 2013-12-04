require 'spec_helper'

describe UserSignUp do
	describe "#sign_up" do
		context "with valid user information and valid credit card stipe token" do
			let(:new_user) { Fabricate.build(:user) }
			let(:customer) { double(:customer_results, successful?: true) }
			before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }

			it "creates a new record" do
				UserSignUp.new(new_user).sign_up(nil, nil)
				expect(User.count).to eq 1
			end	

			context "email sending" do
				it "sends out an email" do
					UserSignUp.new(new_user).sign_up("some valid stripe token", nil)
					expect(ActionMailer::Base.deliveries).to_not be_empty
				end
				it "sends it to the new user" do
					UserSignUp.new(new_user).sign_up("some valid stripe token", nil)
					expect(ActionMailer::Base.deliveries.last.to).to eq [new_user.reload.email]
				end

				it "has the right content" do
					UserSignUp.new(new_user).sign_up("some valid stripe token", nil)
					expect(ActionMailer::Base.deliveries.last.body).to include("your username is: #{new_user.reload.email}")
				end
			end

			context "when valid invitation_token is present" do
				let(:inviter) { Fabricate(:user) }
				let(:invitation) { Fabricate(:invitation, user_id: inviter.id) }

				it "new user is following inviter" do
					UserSignUp.new(new_user).sign_up("some valid stripe token", invitation.token)
					expect(new_user.reload.following_relationships.first.leader).to eq inviter
				end

				it "inviter is following new user" do
					UserSignUp.new(new_user).sign_up("some valid stripe token", invitation.token)
					expect(inviter.reload.following_relationships.first.leader).to eq new_user
				end

				it "expires the invitation" do
					UserSignUp.new(new_user).sign_up("some valid stripe token", invitation.token)
					expect(invitation.reload.token).to eq nil
				end
			end
		end

		context "with invalid inputs" do
			context "with invalid user information" do
				let(:invalid_new_user) { Fabricate.build(:invalid_user) }	

				it "does not create a user" do
					UserSignUp.new(invalid_new_user).sign_up(nil, nil)
					expect(User.count).to eq 0
				end

				it "does not attempt to charge card" do
					StripeWrapper::Charge.should_not_receive(:create)
					UserSignUp.new(invalid_new_user).sign_up(nil, nil)
				end

				it "does not send out any emails" do
					UserSignUp.new(invalid_new_user).sign_up(nil, nil)
					expect(ActionMailer::Base.deliveries).to be_empty
				end

				it "sets an error message" do
					signup = UserSignUp.new(invalid_new_user).sign_up(nil, nil)
					expect(signup.error_message).to eq "User sign up information is invalid."
				end

				it "is not successful" do
					signup = UserSignUp.new(invalid_new_user).sign_up(nil, nil)
					expect(signup.successful?).to eq false
				end
			end

			context "with valid user information and invalid credit card stripe token" do
				let(:new_user) { Fabricate.build(:user) }
				let(:customer) { double(:customer_results, successful?: false, error_message: "This is an error message") }
				before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }
				
				it "does not create a user" do
					UserSignUp.new(new_user).sign_up("some invalid stripe token", nil)
					expect(User.count)
				end
			
				it "sets an error message" do
					signup = UserSignUp.new(new_user).sign_up("some invalid stripe token", nil)
					expect(signup.error_message).to_not be_nil
				end

				it "is not successful" do
					signup = UserSignUp.new(new_user).sign_up("some invalid stripe token", nil)
					expect(signup.successful?).to eq false
				end
			end
		end
	end

	describe "#error_message" do
		context "with invalid user information" do
			it "sets an error message" do
				signup = UserSignUp.new(Fabricate.build(:invalid_user)).sign_up(nil, nil)
				expect(signup.error_message).to eq "User sign up information is invalid."
			end
		end

		context "with valid user information and invalid credit card information" do
			let(:customer) { double(:customer_results, successful?: false, error_message: "This is an error message") }
			before  { StripeWrapper::Customer.should_receive(:create).and_return(customer) }
		
			it "sets an error message" do
				signup = UserSignUp.new(Fabricate.build(:user)).sign_up(nil, nil)
				expect(signup.error_message).to eq "This is an error message"
			end
		end
	end

	describe "#successful?" do
		context "with valid user information and valid credit card information" do
			let(:new_user) { Fabricate.build(:user) }
			let(:customer) { double(:customer_results, successful?: true) }
			before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }

			it "returns true" do
				signup = UserSignUp.new(new_user).sign_up(nil, nil)
				expect(signup.successful?).to eq true
			end
		end
		context "with invalid user information" do
			it "returns false" do
				signup = UserSignUp.new(Fabricate.build(:invalid_user)).sign_up(nil, nil)
				expect(signup.successful?).to eq false
			end
		end

		context "with valid user information and invalid credit card information" do
			let(:new_user) { Fabricate.build(:user) }
			let(:customer) { double(:customer_results, successful?: false, error_message: "This is an error_message") }
			before { StripeWrapper::Customer.should_receive(:create).and_return(customer) }
			it "returns false" do
				signup = UserSignUp.new(new_user).sign_up(nil, nil)
				expect(signup.successful?).to eq false
			end
		end
	end
end