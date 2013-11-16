require 'spec_helper'

feature "my_queue features" do
  scenario "user adds 3 videos to queue,changes positions, changes ratings and removes a video from queue" do
    #create records
    category = Fabricate(:category)
    video1 = Fabricate(:video, category_id: category.id)
    video2 = Fabricate(:video, category_id: category.id)
    video3 = Fabricate(:video, category_id: category.id)

    sign_in

    #click video link and go to video show page
    find(:xpath, "//a[contains(@href,'/videos/#{video1.id}')]").click
    expect(page).to have_content video1.title

    #add video to queue
    click_link "+ My Queue"

    #verify video was added to queue and click link from my_queue page to video show page
    expect(page).to have_content "#{video1.title} has been added to your queue."
    find(:xpath, "//a[contains(@href,'/videos/#{video1.id}')]").click

    #verify add to queue button is no longer on video show page
    expect(page).to have_content "#{video1.title}"
    expect(page).to_not have_content "+ My Queue"

    add_video_to_queue(video2)
    add_video_to_queue(video3)

    #verify all 3 videos are in queue
    expect(page).to have_content "#{video1.title}"
    expect(page).to have_content "#{video2.title}"
    expect(page).to have_content "#{video3.title}"

    #verify positions of videos in queue
    expect_video_position(video1, 1)
    expect_video_position(video2, 2)
    expect_video_position(video3, 3)

    #verify videos have not been rated
    expect_video_rating(video1, nil)
    expect_video_rating(video2, nil)
    expect_video_rating(video3, nil)

    #change positions and rating of videos in queue
    select(1, from: "queue_item_#{video1.id}_rating")
    select(2, from: "queue_item_#{video2.id}_rating")
    select(3, from: "queue_item_#{video3.id}_rating")
    fill_in "queue_item_#{video1.id}_position",  with: "2"
    fill_in "queue_item_#{video2.id}_position",  with: "3"
    fill_in "queue_item_#{video3.id}_position",  with: "1"
    click_button "Update Instant Queue"

    #verify positions and rating change
    expect_video_position(video1, 2)
    expect_video_position(video2, 3)
    expect_video_position(video3, 1)

    expect_video_rating(video1, 1)
    expect_video_rating(video2, 2)
    expect_video_rating(video3, 3)
   end

  def expect_video_position(video, position)
    expect(find_field("queue_item_#{video.id}_position").value).to eq "#{position}"
  end
  
  def expect_video_rating(video, rating)
    expect(find_field("queue_item_#{video.id}_rating").value).to eq "#{rating}"
  end

  def add_video_to_queue(video)
    click_link "MyFLiX" #home page
    find(:xpath, "//a[contains(@href,'/videos/#{video.id}')]").click
    click_link "+ My Queue"
  end

end
