require 'spec_helper'

describe VideosController do
	describe "GET show" do
		it "sets videos variables" do
			test_video  = Fabricate(:video)
			get :show, id: test_video.id
			expect(assigns(:video)).to eq test_video
		end
	end

	describe "GET search" do
		it "sets search variable" do
			test_video1 = Fabricate(:video, title: 'Batman 1')
			test_video2 = Fabricate(:video, title: 'Batman 2')
			test_video3 = Fabricate(:video, title: 'Batman 3')
			test_video4 = Fabricate(:video)
			test_video5 = Fabricate(:video)
			get :search, keyword: "Batman"
			expect(assigns(:search)).to match_array([test_video1, test_video2, test_video3]) 
		end
		it "displays flash notice if search has no results" do
			get :search, keyword: ""
			expect(flash[:notice]).to eq "No videos have been found."
		end
	end
end