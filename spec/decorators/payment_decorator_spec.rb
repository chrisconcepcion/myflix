require 'spec_helper' 

describe PaymentDecorator do
	describe "#user_full_name" do
		context "when payment has a user associated" do
			it "returns the full name of a user" do
				user = Fabricate(:user)
				payment = Fabricate(:payment, user_id: user.id)
				expect(PaymentDecorator.decorate(payment).user_full_name).to eq user.full_name
			end
		end
		context "when payment doesn't have a user associated" do
			it "returns nil" do
				payment = Fabricate(:payment)
				expect(PaymentDecorator.decorate(payment).user_full_name).to eq nil
			end
		end
	end

	describe "#formatted_amount" do
		it "returns a payment amount in dollar and cent format" do
			payment = Fabricate(:payment)
			expect(PaymentDecorator.decorate(payment).formatted_amount).to eq "$9.99"
		end
	end
	describe "#user_email" do
		context "when payment has a user associated" do
			it "returns the email of a user" do
				user = Fabricate(:user)
				payment = Fabricate(:payment, user_id: user.id)
				expect(PaymentDecorator.decorate(payment).user_email).to eq user.email
			end
		end
		context "when payment doesn't have a user associated" do
			it "returns nil" do
				payment = Fabricate(:payment)
				expect(PaymentDecorator.decorate(payment).user_email).to eq nil
			end
		end
	end
end