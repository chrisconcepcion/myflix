require 'spec_helper'

describe CategoryDecorator do
	describe "#recent_videos" do
		it "returns 6 videos in reverse chronological order when there is more than 6 videos" do
			test_category = Fabricate(:category)
			test_video1 = Fabricate(:video, category_id: test_category.id)
			test_video2 = Fabricate(:video, category_id: test_category.id)
			test_video3 = Fabricate(:video, category_id: test_category.id)
			test_video4 = Fabricate(:video, category_id: test_category.id)
			test_video5 = Fabricate(:video, category_id: test_category.id)
			test_video6 = Fabricate(:video, category_id: test_category.id)
			test_video7 = Fabricate(:video, category_id: test_category.id)
			test_video8 = Fabricate(:video, category_id: test_category.id)
			expect((test_category.decorate).recent_videos).to eq [test_video8, test_video7, test_video6, test_video5, test_video4, test_video3]
		end
		it "returns the 6 videos in reverse chronilogical order when there is only 6 videos " do
			test_category = Fabricate(:category)
			test_video1 = Fabricate(:video, category_id: test_category.id)
			test_video2 = Fabricate(:video, category_id: test_category.id)
			test_video3 = Fabricate(:video, category_id: test_category.id)
			test_video4 = Fabricate(:video, category_id: test_category.id)
			test_video5 = Fabricate(:video, category_id: test_category.id)
			test_video6 = Fabricate(:video, category_id: test_category.id)
			expect((test_category.decorate).recent_videos).to eq [test_video6, test_video5, test_video4, test_video3, test_video2, test_video1]
		end
		it "returns all videos in reverse chronological order when there is less than 6 videos" do
			test_category = Fabricate(:category)
			test_video1 = Fabricate(:video, category_id: test_category.id)
			test_video2 = Fabricate(:video, category_id: test_category.id)
			test_video3 = Fabricate(:video, category_id: test_category.id)
			test_video4 = Fabricate(:video, category_id: test_category.id)
			test_video5 = Fabricate(:video, category_id: test_category.id)
			expect((test_category.decorate).recent_videos).to eq [test_video5, test_video4, test_video3, test_video2, test_video1]
		end
	end
end	