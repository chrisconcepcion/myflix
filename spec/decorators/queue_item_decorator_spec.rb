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

	describe "#rating" do
		context "when user has reviewed queued video"
			it "returns rating of queued video" do
				user = Fabricate(:user)
				video = Fabricate(:video)
				review = Fabricate(:review, user_id: user.id, video_id: video.id, rating: 3)
				queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
				expect(QueueItemDecorator.decorate(queue_item).rating).to eq 3
			end
		context "when user has not reviewed queue video" do
			it "returns nil" do
				user = Fabricate(:user)
				video = Fabricate(:video)
				queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
				expect(QueueItemDecorator.decorate(queue_item).rating).to eq nil
			end
		end
	end

	describe "#video_category" do
		it "returns the video category of queued video" do
			user = Fabricate(:user)
			category = Fabricate(:category)
			video = Fabricate(:video, category_id: category.id)
			queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
			expect(QueueItemDecorator.decorate(queue_item).video_category).to eq category
		end
	end
end