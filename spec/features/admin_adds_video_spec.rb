require 'spec_helper'

feature 'Admin adds a video' do
	background { Category.create(name: "TV Comedy") }
	scenario "admin logins in, adds a video, goes to newly added video's display page and confirms video location is present under button" do
		admin_sign_in
		visit new_admin_video_path
		fill_in "Title", with: "South Park"
		fill_in "Description", with: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado."
		attach_file("Large cover", File.expand_path("#{Rails.root}/public/tmp/south_park.jpg"))
		attach_file("Small cover", File.expand_path("#{Rails.root}/public/tmp/south_park.jpg"))
		fill_in "Location", with: "http://www.youtube.com/watch?v=VHoT4N43jK8"
		click_button "Add Video"
		click_link "Videos"
		expect(page).to have_xpath("//img[contains(@src, '#{Video.first.small_cover}')]")
		find_video_by_title_and_click("South Park")
		expect(page).to have_xpath("//a[contains(@href, 'http://www.youtube.com/watch?v=VHoT4N43jK8')]")	
	end

	def find_video_by_title_and_click(title)
		find(:xpath, "//a[contains(@href,'/videos/#{Video.find_by(title: "#{title}").id}')]").click
	end
end


