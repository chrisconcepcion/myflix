Stripe.api_key = ENV['STRIPE_SECRET_KEY'] 

StripeEvent.setup do
  subscribe 'charge.succeeded' do |event|
    user = User.find_by(customer_token: event.data.object.customer)
    Payment.create(user_id: user.id, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  subscribe "charge.failed" do |event|
    user = User.find_by(customer_token: event.data.object.customer)
    user.deactivate!
    UserMailer.delay.locked_account(user)
  end
end