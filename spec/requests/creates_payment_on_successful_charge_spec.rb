require 'spec_helper'

describe "creates payment on successful charge" do
	let(:event_object) do
		{
  "id" => "evt_1032Ka2KoHO1hwu4nr7c2eqP",
  "created" => 1385826311,
  "livemode" => false,
  "type" => "charge.succeeded",
  "data" => {
    "object" => {
      "id" => "ch_1032Ka2KoHO1hwu4GC6c6KAB",
      "object" => "charge",
      "created" => 1385826311,
      "livemode" => false,
      "paid" => true,
      "amount" => 999,
      "currency" => "usd",
      "refunded" => false,
      "card" => {
        "id" => "card_1032Ka2KoHO1hwu4DAv5EMB4",
        "object" => "card",
        "last4" => "4242",
        "type" => "Visa",
        "exp_month" => 12,
        "exp_year" => 2017,
        "fingerprint" => "fJqnJX9xYesNslvE",
        "customer" => "cus_32KaJ6LPZDwQln",
        "country" => "US",
        "name" => nil,
        "address_line1" => nil,
        "address_line2" => nil,
        "address_city" => nil,
        "address_state" => nil,
        "address_zip" => nil,
        "address_country" => nil,
        "cvc_check" => "pass",
        "address_line1_check" => nil,
        "address_zip_check" => nil
      },
      "captured" => true,
      "refunds" => [],
      "balance_transaction" => "txn_1032Ka2KoHO1hwu4RO6RgiXN",
      "failure_message" => nil,
      "failure_code" => nil,
      "amount_refunded" => 0,
      "customer" => "cus_32KaJ6LPZDwQln",
      "invoice" => "in_1032Ka2KoHO1hwu4MwC7f3d7",
      "description" => nil,
      "dispute" => nil,
      "metadata" => {}
    }
  },
  "object" => "event",
  "pending_webhooks" => 3,
  "request" => "iar_32KaYTQs4RUKpk"
}
end

	it "creates a payment", :vcr do
		user = Fabricate(:user, customer_token: "cus_32KaJ6LPZDwQln" )
		post "/stripe_events", event_object
		expect(Payment.count).to eq 1
	end

	it "creates a payment associated with a user", :vcr do
		user = Fabricate(:user, customer_token: "cus_32KaJ6LPZDwQln" )
		post "/stripe_events", event_object
		expect(Payment.first.user).to eq user
	end

	it "creates a payment with reference id", :vcr do
		user = Fabricate(:user, customer_token: "cus_32KaJ6LPZDwQln" )
		post "/stripe_events", event_object
		expect(Payment.first.reference_id).to eq "ch_1032Ka2KoHO1hwu4GC6c6KAB"
	end

	it "creates a payment with amount", :vcr do
			user = Fabricate(:user, customer_token: "cus_32KaJ6LPZDwQln" )
		post "/stripe_events", event_object
		expect(Payment.first.amount).to eq 999
	end
end