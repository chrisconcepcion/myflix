require 'spec_helper'

feature "User Signs in" do
	scenario "Signing in with existing credentials" do
		sign_in
    expect(page).to have_content "You have logged in successfully."
	end
end