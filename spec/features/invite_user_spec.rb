require 'spec_helper'

feature "Invite User", js: true do
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
		expect(find_field('Email').value.should eq 'testing@test.com')
		fill_in "Password", with: "testing"
		fill_in "Full name", with: "Testing McTestingson"
		fill_in "Credit Card Number", with: '4242424242424242'
		fill_in "Security Code", with: '123'
		select(12, :from => "date_month")
    select(2017, :from => "date_year")
		click_button "Sign Up"
		sleep 10
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