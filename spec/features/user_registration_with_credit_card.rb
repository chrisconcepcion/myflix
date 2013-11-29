require 'spec_helper'

feature 'User Registration with Credit Card',js: true do
	background do
		visit register_path
	end

	scenario 'Vistor submits valid input for user form and valid credit card' do
		valid_user_form_and_credit_card('4242424242424242')
		page.should have_content "You have successfully registered and will be logged in."
	end
	
	scenario "Vistor submits valid input for user form and invalid credit card" do
		valid_user_form_and_credit_card('4000000000000069')
		page.should have_content "Your card's expiration date is incorrect."
	end

	scenario "Vistor submits valid input for user form and delined credit card" do
		valid_user_form_and_credit_card('40000000000002')
		page.should have_content "Your card was declined."
	end

	scenario "Vistor submits invalid input for user form and valid credit card" do
		invalid_user_form_and_credit_card('4242424242424242')
	end
	scenario "Vistor submits invalid input for user form and invalid credit card" do
		invalid_user_form_and_credit_card('4000000000000069')
	end
	scenario "Vistor submits invalid input for user form and declined credit card" do
		invalid_user_form_and_credit_card('4000000000000002')
	end

	def valid_user_form_and_credit_card(card_number)
		fill_in 'Email', with: 'testing123@example.com'
		fill_in 'Password', with: 'example'
		fill_in 'Full name', with: 'ricky bobby'
		fill_in 'Credit Card Number', with: card_number
		fill_in 'Security Code', with: '123'
		select(12, :from => "date_month")
		select(2017, :from => "date_year")
		click_button "Sign Up"
		sleep 10
	end

	def invalid_user_form_and_credit_card(card_number)
		fill_in 'Email', with: 'testing123@example.com'
		fill_in 'Full name', with: 'ricky bobby'
		fill_in 'Credit Card Number', with: card_number
		fill_in 'Security Code', with: '123'
		select(12, :from => "date_month")
		select(2017, :from => "date_year")
		click_button "Sign Up"
		sleep 10
		page.should have_content "User sign up information is invalid."
	end

end