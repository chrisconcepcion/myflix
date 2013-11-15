require 'spec_helper'

feature "User Signs in" do
	given(:user) { Fabricate(:user) }

	scenario "Signing in with existing credentials" do
		visit '/sign_in'

		fill_in "Email", with: user.email
		fill_in "Password", with: user.password

		click_button "Sign in"

		expect(page).to have_content "Welcome, #{user.full_name}"
	end
end