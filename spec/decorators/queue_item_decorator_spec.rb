require 'spec_helper'

describe QueueItemDecorator do 
	describe "#video_title" do
		it "returns the video title" do
			user = Fabricate(:user)
			video = Fabricate(:video)
			queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
			expect(QueueItemDecorator.decorate(queue_item).video_title).to eq queue_item.video.title
		end
	end

	describe "#video_genre" do
		it "returns video category name" do
			user = Fabricate(:user)
			category = Fabricate(:category)
			video = Fabricate(:video, category_id: category.id)
			queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
			expect(QueueItemDecorator.decorate(queue_item).video_genre).to eq queue_item.video.category.name
		end
	end
end