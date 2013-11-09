require 'spec_helper'

describe ReviewDecorator do
	describe "#reviewer_name" do
		it "returns reviewers full name" do
			test_user = Fabricate(:user)
			test_video = Fabricate(:video)
			test_review = Fabricate(:review, video_id: test_video.id, user_id: test_user.id )
			expect((test_review.decorate).reviewer_name).to eq test_user.full_name
		end
	end
end