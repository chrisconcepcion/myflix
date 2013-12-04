require 'spec_helper'

feature "Admin sees user payments" do
	given(:user) { Fabricate(:user) }
	background { Payment.create(amount: 999, reference_id: 'reference_id_test', user_id: user.id) }

	scenario "Admin logs in and sees payment" do
		admin_sign_in
		visit admin_payments_path
		expect(page).to have_content user.full_name
		expect(page).to have_content user.email
		expect(page).to have_content "$9.99"
		expect(page).to have_content "reference_id_test"
	end
end