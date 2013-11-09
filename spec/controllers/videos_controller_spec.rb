require 'spec_helper'

describe VideosController do
	describe "GET show" do
		let(:video)  { Fabricate(:video) }
		context "when authenticated" do
			it "sets video variables" do
				set_current_user
				get :show, id: video.id
				expect(assigns(:video)).to eq video
			end

			it "decorates video variable" do
				set_current_user
				get :show, id: video.id
				expect(assigns(:video)).to be_decorated_with VideoDecorator
			end

			it "sets review variable" do
				set_current_user
				review = Fabricate(:review, video_id: video.id, user_id: current_user.id)
				get :show, id: video.id
				expect(assigns(:reviews)).to eq [review]
			end

			it "decorates review variable" do
				set_current_user
				review = Fabricate(:review, video_id: video.id, user_id: current_user.id)
				get :show, id: video.id
				expect(assigns(:reviews)).to be_decorated
			end
		end



		it_behaves_like "when not authenticated" do
			let(:action) { get :show, id: video.id }
		end
	end

	describe "GET search" do
		context "when authenticated" do
			it "sets search variable" do
				set_current_user
				video1 = Fabricate(:video, title: 'Batman 1')
				video2 = Fabricate(:video, title: 'Batman 2')
				video3 = Fabricate(:video, title: 'Batman 3')
				video4 = Fabricate(:video)
				video5 = Fabricate(:video)
				get :search, keyword: "Batman"
				expect(assigns(:search)).to match_array([video1, video2, video3]) 
			end
			it "displays flash notice if search has no results" do
				set_current_user
				video1 = Fabricate(:video, title: 'Batman 1')
				video2 = Fabricate(:video, title: 'Batman 2')
				video3 = Fabricate(:video, title: 'Batman 3')
				get :search, keyword: ""
				expect(flash[:notice]).to eq "No videos have been found."
			end
		end
	end

	it_behaves_like "when not authenticated" do
		let(:action) { get :search, keyword: ""}
	end
end