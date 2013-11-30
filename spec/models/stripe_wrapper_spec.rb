require 'spec_helper'

describe StripeWrapper::Charge do
	let(:valid_credit_card_token) { Stripe::Token.create(card: { number: 4242424242424242, exp_month: 12, exp_year: 2022, cvc: 123}) }
	let(:invalid_credit_card_token) { Stripe::Token.create(card: { number: 4000000000000002, exp_month: 12, exp_year: 2022, cvc: 123}) }
	before { StripeWrapper.set_api_key }

	describe ".create" do
		describe "with valid card", :vcr do
			it "charges card successfully" do
				charge = StripeWrapper::Charge.create(amount: 999, currency: 'usd', card: valid_credit_card_token.id)
				expect(charge.successful?).to eq true
			end
		end

		describe "with invalid card", :vcr do
			it "does not charge card" do
				charge = StripeWrapper::Charge.create(amount: 999, currency: 'usd', card: invalid_credit_card_token.id)
				expect(charge.successful?).to eq false
			end

			it "returns an error message", :vcr do
				charge = StripeWrapper::Charge.create(amount: 999, currency: 'usd', card: invalid_credit_card_token.id)
				expect(charge.error_message).to eq "Your card was declined."
			end
		end
	end
end

describe StripeWrapper::Customer do
	let(:valid_credit_card_token) { Stripe::Token.create(card: { number: 4242424242424242, exp_month: 12, exp_year: 2022, cvc: 123}) }
	let(:invalid_credit_card_token) { Stripe::Token.create(card: { number: 4000000000000002, exp_month: 12, exp_year: 2022, cvc: 123}) }
	let(:new_user) { Fabricate(:user) }
	before { StripeWrapper.set_api_key }

	describe ".create" do
		describe "with valid card" do
			it "creates a customer", :vcr do
				charge = StripeWrapper::Customer.create(email: new_user.email, card: valid_credit_card_token.id)
				expect(charge.successful?).to eq true
			end
		end

		describe "with invalid card"  do
			it "does not create a customer", :vcr do
				charge = StripeWrapper::Customer.create(email: new_user.email, card: invalid_credit_card_token.id)
				expect(charge.successful?).to eq false
			end

			it "returns an error message", :vcr do
				charge = StripeWrapper::Customer.create(email: new_user.email, card: invalid_credit_card_token.id)
				expect(charge.error_message).to eq "Your card was declined."
			end
		end
	end
end