require 'spec_helper'

describe QueueItem do 
	it { should belong_to(:user) }
	it { should belong_to(:video) }
	it { should validate_presence_of(:user_id) }
	it { should validate_presence_of(:video_id) }
	it { should validate_uniqueness_of(:video_id).scoped_to(:user_id)}

	describe "#create_position" do
		context "when user has one queue_item" do
			it "sets queue_item position 1" do
				user = Fabricate(:user)
				video = Fabricate(:video)
				queue_item = QueueItem.create(video_id: video.id, user_id: user.id)
				queue_item.create_position
				expect(queue_item.position).to eq 1
			end
		end
		
		context "when user has items in queue" do
			it "sets queue_item position to 1 greater than highest positioned queue_item" do
				user = Fabricate(:user)
				video1 = Fabricate(:video)
				video2 = Fabricate(:video)
				video3 = Fabricate(:video)
				queue_item1 = Fabricate(:queue_item, position: 1, video_id: video1.id, user_id: user.id)
				queue_item2 = Fabricate(:queue_item, position: 2, video_id: video2.id, user_id: user.id)
				queue_item3 = QueueItem.create(video_id: video3.id, user_id: user.id)
				queue_item3.create_position
				expect(queue_item3.position).to eq 3
			end
		end
	end
end