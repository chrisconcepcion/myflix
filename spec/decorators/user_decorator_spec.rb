require 'spec_helper'

describe UserDecorator do
	describe "#total_queue_items" do
		it "returns the total count of queue_items" do
			user = Fabricate(:user)
			video1 = Fabricate(:video)
			video2 = Fabricate(:video)
			queue_item1 = Fabricate(:queue_item, user_id: user.id, video_id: video1.id)
			queue_item2 = Fabricate(:queue_item, user_id: user.id, video_id: video2.id)
			expect(UserDecorator.decorate(user).total_queue_items).to eq 2
		end
	end

	describe "#queued_video_title" do
		it "returns a queued video title" do
			user = Fabricate(:user)
			video = Fabricate(:video)
			queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
			expect(UserDecorator.decorate(user).queued_video_title(queue_item)).to eq queue_item.video.title
		end
	end

	describe "#queued_video_category_name" do
		context "when queued video has a category" do
			it "returns a queued video category name" do
				user = Fabricate(:user)
				category = Fabricate(:category)
				video = Fabricate(:video, category_id: category.id)
				queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
				expect(UserDecorator.decorate(user).queued_video_category_name(queue_item)).to eq video.category.name
			end
		end

		context "when queued video does not have a category" do
			it "returns nil" do
				user = Fabricate(:user)
				video = Fabricate(:video)
				queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
				expect(UserDecorator.decorate(user).queued_video_category_name(queue_item)).to eq nil
			end
		end
	end

	describe "#queued_video_category" do
		context "when queued video has a category" do
			it "returns a category" do
				user = Fabricate(:user)
				category = Fabricate(:category)
				video = Fabricate(:video, category_id: category.id)
				queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
				expect(UserDecorator.decorate(user).queued_video_category(queue_item)).to eq category
			end
		end

		context "when queued video does not have a category" do
			it "returns nil" do
				user = Fabricate(:user)
				video = Fabricate(:video)
				queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
				expect(UserDecorator.decorate(user).queued_video_category(queue_item)).to eq nil
			end
		end
	end

	describe "#reviewed_video_title" do
		it "returns a reviewed video title" do
			user = Fabricate(:user) 
			video = Fabricate(:video)
			review = Fabricate(:review, video_id: video.id, user_id: user.id)
			expect(UserDecorator.decorate(user).reviewed_video_title(review)).to eq video.title
		end
	end 

	describe "#total_reviews" do
		it "returns total count of reviews" do
			user = Fabricate(:user)
			video = Fabricate(:video)
			review = Fabricate(:review, video_id: video.id, user_id: user.id) 
			expect(UserDecorator.decorate(user).total_reviews).to eq 1
		end
	end
end