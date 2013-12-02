require 'spec_helper'

describe "locks users account on failed payment" do
	let(:event_object) do
		{
  "id" => "evt_102q7V2KoHO1hwu4nZPta2dL",
  "created" => 1383009961,
  "livemode" => false,
  "type" => "charge.failed",
  "data" => {
    "object" => {
      "id" => "ch_102q7V2KoHO1hwu4SVPEn40p",
      "object" => "charge",
      "created" => 1383009961,
      "livemode" => false,
      "paid" => false,
      "amount" => 999,
      "currency" => "usd",
      "refunded" => false,
      "card" => {
        "id" => "card_102q7V2KoHO1hwu4gCJxKh3k",
        "object" => "card",
        "last4" => "0341",
        "type" => "Visa",
        "exp_month" => 11,
        "exp_year" => 2014,
        "fingerprint" => "doD7JazzGADxWbL4",
        "customer" => nil,
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
      "captured" => false,
      "refunds" => [],
      "balance_transaction" => nil,
      "failure_message" => "Your card was declined.",
      "failure_code" => "card_declined",
      "amount_refunded" => 0,
      "customer" => "cus_2q69eR4B3M0rG6",
      "invoice" => nil,
      "description" => "test",
      "dispute" => nil,
      "metadata" => {}
    }
  },
  "object" => "event",
  "pending_webhooks" => 1,
  "request" => "iar_2q7VA2TuQ3slOm"
}


end
  
  it "sets user to inactive" do
    user = Fabricate(:user, customer_token: "cus_2q69eR4B3M0rG6" )
    post "/stripe_events", event_object
    expect(user.reload.active).to eq false
  end

  it "emails the user" do
    user = Fabricate(:user, customer_token: "cus_2q69eR4B3M0rG6" )
    post "/stripe_events", event_object
    expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
  end

  it "emails the user notifying of payment failure and locked account" do
    user = Fabricate(:user, customer_token: "cus_2q69eR4B3M0rG6" )
    post "/stripe_events", event_object
    expect(ActionMailer::Base.deliveries.last.body).to include "#{user.full_name}, your credit card was declined when attempted to be charged for your MyFlix subscription. Please contact customer service to resolve the issue. Your account has been set to inactive and our services will be unavailable to you until the issue has been resolved."
  end
end
