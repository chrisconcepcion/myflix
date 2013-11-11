require 'spec_helper'

describe ReviewsController do
	describe "POST create" do
		let(:video) { Fabricate(:video) }

		context "when authenticated" do
			context "with valid input" do
				it "creates a review" do
					set_current_user
					post :create, review: Fabricate.attributes_for(:review), video_id: video.id
					expect(Review.count).to eq 1
				end

				it "creates a review associated with a video" do
					set_current_user
					post :create, review: Fabricate.attributes_for(:review), video_id: video.id
					expect(video.reviews.count).to eq 1
				end

				it "creates a review associated with an user" do
					set_current_user
					post :create, review: Fabricate.attributes_for(:review), video_id: video.id
					expect(current_user.reviews.count).to eq 1
				end

				it "displays a flash notice" do
					set_current_user
					post :create, review: Fabricate.attributes_for(:review), video_id: video.id
					expect(flash[:notice]).to eq "Your review has been posted."
				end

				it "redirects to video" do
					set_current_user
					post :create, review: Fabricate.attributes_for(:review), video_id: video.id
					expect(response).to redirect_to video_path(video.id)
				end
			end	

			context "with invalid input" do
				it "renders video page" do
					set_current_user
					post :create, review: { description: ""} , video_id: video.id
					expect(response).to render_template "videos/show"
				end

				it "does not create a review" do
					set_current_user
					post :create, review: { description: ""} , video_id: video.id
					expect(Review.count).to eq 0
				end
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { post :create, video_id: video.id, review: { description: "fail" } }
		end
	end
end