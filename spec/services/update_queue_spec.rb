require 'spec_helper'

describe UpdateQueue do
	describe "#update_queue" do
		let(:user) { Fabricate(:user) }
		let(:video1) { Fabricate(:video) }
		let(:video2) { Fabricate(:video) } 
		let(:video3) { Fabricate(:video) }
		let(:queue_item1) { Fabricate(:queue_item, position: 1, video_id: video1.id, user_id: user.id) }
		let(:queue_item2) { Fabricate(:queue_item, position: 2, video_id: video2.id, user_id: user.id) }
		let(:queue_item3) { Fabricate(:queue_item, position: 3, video_id: video3.id, user_id: user.id) }
		
		context "when inputs are valid" do
			it "updates queued videos positions" do
				valid_update_hash = [{id: queue_item1.id, position: 2, rating: 5}, {id: queue_item2.id, position: 3, rating: 5}, { id: queue_item3.id, position: 1, rating: 5}] 
				UpdateQueue.new(user).update_queue(valid_update_hash)
				expect(queue_item1.reload.position).to eq 2
				expect(queue_item2.reload.position).to eq 3
				expect(queue_item3.reload.position).to eq 1
			end

			context "when queued videos have been reviewed" do
				it "updates queued videos ratings" do
					valid_update_hash = [{id: queue_item1.id, position: 2, rating: 5}, {id: queue_item2.id, position: 3, rating: 5}, { id: queue_item3.id, position: 1, rating: 5}] 
					review1 = Fabricate(:review, video_id: video1.id, rating: 1, user_id: user.id)
					review2 = Fabricate(:review, video_id: video2.id, rating: 1, user_id: user.id)
					review3 = Fabricate(:review, video_id: video3.id, rating: 1, user_id: user.id)
					UpdateQueue.new(user).update_queue(valid_update_hash)
					expect(review1.reload.rating).to eq 5
					expect(review2.reload.rating).to eq 5
					expect(review3.reload.rating).to eq 5
				end
			end

			context "when queued videos have not been reviewed" do
				it "creates a review for videos rated" do
					valid_update_hash = [{id: queue_item1.id, position: 2, rating: 5}, {id: queue_item2.id, position: 3, rating: 5}, { id: queue_item3.id, position: 1, rating: 5}] 
					UpdateQueue.new(user).update_queue(valid_update_hash)
					expect(user.reviews.count).to eq 3
				end
				it "creates a review with rating for videos rated" do
					valid_update_hash = [{id: queue_item1.id, position: 2, rating: 5}, {id: queue_item2.id, position: 3, rating: 5}, { id: queue_item3.id, position: 1, rating: 5}] 
					UpdateQueue.new(user).update_queue(valid_update_hash)
					expect(queue_item1.video.reviews.find_by(user_id: user.id).rating).to eq 5
					expect(queue_item2.video.reviews.find_by(user_id: user.id).rating).to eq 5
					expect(queue_item3.video.reviews.find_by(user_id: user.id).rating).to eq 5 
				end
			end
		end

		context "when inputs are invalid" do
			it "doesn't update queued videos positions" do
				invalid_update_hash = [{id: queue_item1.id, position: 2, rating: 5}, {id: queue_item2.id, position: 2, rating: 5}, { id: queue_item3.id, position: "lol", rating: 5}] 
				UpdateQueue.new(user).update_queue(invalid_update_hash)
				expect(queue_item1.reload.position).to eq 1
				expect(queue_item2.reload.position).to eq 2
				expect(queue_item3.reload.position).to eq 3
			end
			context "when queued videos have been reviewed" do
				it "doesn't update queued videos ratings" do
					review1 = Fabricate(:review, video_id: video1.id, rating: 1, user_id: user.id)
					review2 = Fabricate(:review, video_id: video2.id, rating: 1, user_id: user.id)
					review3 = Fabricate(:review, video_id: video3.id, rating: 1, user_id: user.id)
					invalid_update_hash = [{id: queue_item1.id, position: 2, rating: 5}, {id: queue_item2.id, position: 2, rating: 5}, { id: queue_item3.id, position: "lol", rating: 5}] 
					UpdateQueue.new(user).update_queue(invalid_update_hash)
					expect(review1.reload.rating).to eq 1
					expect(review2.reload.rating).to eq 1
					expect(review3.reload.rating).to eq 1
				end
			end
			context "when queued videos have not been reviewed" do
				it "doesn't create queued video reviews" do
					invalid_update_hash = [{id: queue_item1.id, position: 2, rating: 5}, {id: queue_item2.id, position: 2, rating: 5}, { id: queue_item3.id, position: "lol", rating: 5}] 
					UpdateQueue.new(user).update_queue(invalid_update_hash)
					expect(user.reviews.count).to eq 0
				end
			end
		end
	end
end