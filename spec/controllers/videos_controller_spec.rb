require 'spec_helper'

describe VideosController do
	describe "GET show" do
		it "sets videos variables" do
			test_video  = Fabricate(:video)
			get :show, id: test_video.id
			expect(assigns(:video)).to eq test_video
		end
	end
end