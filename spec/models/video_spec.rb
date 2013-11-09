require 'spec_helper'

describe Video do
	it { should belong_to(:category) }
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }
	it { should validate_presence_of(:small_cover_url) }
	it { should validate_presence_of(:large_cover_url)}

	describe "#search_by_title" do
		it "returns blank array when keyword is blank" do
			test_video = Fabricate(:video)
			expect(Video.search_by_title("")).to eq []
		end
		it "returns a blank array when no title match the keyword" do
			test_video1 = Fabricate(:video, title: 'Batman 1')
			test_video2 = Fabricate(:video, title: 'Batman 2' )
			test_video3 = Fabricate(:video, title: 'Monk')
			test_video4 = Fabricate(:video, title: 'South Park')
			expect(Video.search_by_title('George')).to eq []
		end
		it "returns array of videos that title matches the keyword" do
			test_video1 = Fabricate(:video, title: 'Batman 1')
			test_video2 = Fabricate(:video, title: 'Batman 2' )
			test_video3 = Fabricate(:video, title: 'Monk')
			test_video4 = Fabricate(:video, title: 'South Park')
			expect(Video.search_by_title("Batman")).to match_array([test_video1, test_video2])
		end
		
	end
end