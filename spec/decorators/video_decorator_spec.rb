require 'spec_helper'

describe VideoDecorator do
	describe "#average_rating" do
		let(:video) { Fabricate(:video) }
		context "when video has reviews" do
			it "returns of the average rating of a video" do
				review1 = Fabricate(:review, rating: 5, video_id: video.id)
				review2 = Fabricate(:review, rating: 4, video_id: video.id)
				expect(VideoDecorator.decorate(video).average_rating).to eq '4.50'
			end
		end
		context "when video has not reviews" do
			it "returns nil" do
				expect(VideoDecorator.decorate(video).average_rating).to eq nil
			end
		end
	end
end