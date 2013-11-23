require 'spec_helper'

feature "Invite User" do
	background { clear_email }
	given (:inviter) { Fabricate(:user) } 
	scenario "User sends an invitation to join MyFLix and user registers" do
		sign_in(inviter)
		click_link "Invite"
		fill_in "Friend's Name", with: "Testing McTestingson"
		fill_in "Friend's Email Address", with: "testing@test.com"
		fill_in "Invitation Message", with: "Join this awesome site!"
		click_button "Send Invitation"
		sign_out
		open_email("testing@test.com")
		current_email.click_link "here"
		fill_in "Password", with: "testing"
		fill_in "Full name", with: "Testing McTestingson"
		click_button "Sign Up"
		fill_in "Email", with: "testing@test.com"
		fill_in "Password", with: "testing"
		click_button "Sign in"
		click_link "People"
		expect(page).to have_content "People I Follow"
		expect(page).to have_content "#{inviter.full_name}"
		sign_out
		sign_in(inviter)
		click_link "People"
		expect(page).to have_content "People I Follow"
		expect(page).to have_content "Testing McTestingson"
	end
end