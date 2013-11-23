require 'spec_helper'

feature "Reset Password" do
	background { clear_emails }
	scenario "User resets password and logs in with new password" do
		
		user = Fabricate(:user)
		visit forgot_password_path
		fill_in "email", with: user.email
		click_button "Send Email"
		open_email(user.email)
		current_email.click_link "link"
		fill_in "password", with: "feature_spec"
		click_button "Reset Password"
		fill_in "email", with: user.email
		fill_in "password", with: "feature_spec"
		click_button "Sign in"
		expect(page).to have_content "You have logged in successfully."
	end
end