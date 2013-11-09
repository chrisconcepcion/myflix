require 'spec_helper'

describe VideosController do
	describe "GET show" do
		let(:test_video)  { Fabricate(:video) }
		context "when authenticated" do
			it "sets videos variables" do
				set_current_user
				get :show, id: test_video.id
				expect(assigns(:video)).to eq test_video
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :show, id: test_video.id }
		end
	end

	describe "GET search" do
		context "when authenticated" do
			it "sets search variable" do
				set_current_user
				test_video1 = Fabricate(:video, title: 'Batman 1')
				test_video2 = Fabricate(:video, title: 'Batman 2')
				test_video3 = Fabricate(:video, title: 'Batman 3')
				test_video4 = Fabricate(:video)
				test_video5 = Fabricate(:video)
				get :search, keyword: "Batman"
				expect(assigns(:search)).to match_array([test_video1, test_video2, test_video3]) 
			end
			it "displays flash notice if search has no results" do
				set_current_user
				test_video1 = Fabricate(:video, title: 'Batman 1')
				test_video2 = Fabricate(:video, title: 'Batman 2')
				test_video3 = Fabricate(:video, title: 'Batman 3')
				get :search, keyword: ""
				expect(flash[:notice]).to eq "No videos have been found."
			end
		end
	end

	it_behaves_like "when not authenticated" do
		let(:action) { get :search, keyword: ""}
	end
end