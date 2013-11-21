require 'spec_helper'

describe RelationshipDecorator do
	describe "#leader_total_queue_items" do
		it "returns total of videos queued by a user" do
			user = Fabricate(:user)
			follower = Fabricate(:user)
			video = Fabricate(:video)
			relationship = Fabricate(:relationship, leader_id: user.id, follower_id: follower.id)
			queue_item = Fabricate(:queue_item, user_id: user.id, video_id: video.id)
			expect(RelationshipDecorator.decorate(relationship).leader_total_queue_items).to eq 1
		end
	end
	
	describe "#leader_total_followers" do
		it "returns total number of followers a user has" do
			user = Fabricate(:user)
			follower = Fabricate(:user)
			relationship = Fabricate(:relationship, leader_id: user.id, follower_id: follower.id)
			expect(RelationshipDecorator.decorate(relationship).leader_total_followers).to eq 1
		end
	end

	describe "#leader_email" do
		it "returns leader email" do
			user = Fabricate(:user)
			follower = Fabricate(:user)
			relationship = Fabricate(:relationship, leader_id: user.id, follower_id: follower.id)
			expect(RelationshipDecorator.decorate(relationship).leader_email).to eq user.email
		end
	end

	describe "#leader_name" do
		it "returns leader name" do
			user = Fabricate(:user)
			follower = Fabricate(:user)
			relationship = Fabricate(:relationship, leader_id: user.id, follower_id: follower.id)
			expect(RelationshipDecorator.decorate(relationship).leader_name).to eq user.full_name
		end
	end
end