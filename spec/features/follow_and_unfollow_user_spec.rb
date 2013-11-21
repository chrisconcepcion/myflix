require 'spec_helper'

feature "Follow and unfollow a user" do
	scenario "User signs in, follows a user and then unfollow user" do
		#create records
		category = Fabricate(:category)
		video = Fabricate(:video, category_id: category.id)
		test_user = Fabricate(:user)
		review = Fabricate(:review, video_id: video.id, user_id: test_user.id)

		sign_in

		find(:xpath, "//a[contains(@href, '/videos/#{video.id}')]").click

		find(:xpath, "//a[contains(@href, '/users/#{test_user.id}')]").click

		click_link "Follow"

		click_link "People"

		expect(page).to have_content "#{test_user.full_name}"

		click_link "end_relationship_#{User.last.following_relationships.find_by(id: test_user.id).id}"

		click_link "People"
		
		expect(page).to_not have_content "#{test_user.full_name}"
	end
end