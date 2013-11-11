require 'spec_helper'

describe QueueItemsController do 
	describe "GET index" do
		context "when authenicated" do
			it "sets the queue_items variable" do
				set_current_user
				video1 = Fabricate(:video)
				video2 = Fabricate(:video)
				queue_item1 = Fabricate(:queue_item, position: 1, video_id: video1.id, user_id: current_user.id)
				queue_item2 = Fabricate(:queue_item, position: 2, video_id: video2.id, user_id: current_user.id)
				get :index
				expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
			end

			it "decorators queue_items variable" do
				set_current_user
				video1 = Fabricate(:video)
				video2 = Fabricate(:video)
				queue_item1 = Fabricate(:queue_item, position: 1, video_id: video1.id, user_id: current_user.id)
				queue_item2 = Fabricate(:queue_item, position: 2, video_id: video2.id, user_id: current_user.id)
				get :index
				expect(assigns(:queue_items).class).to eq Draper::CollectionDecorator
			end
		end
		
		it_behaves_like "when not authenticated" do
			let(:action) { get :index }
		end
	end

	describe "POST create" do
		context "when authenticated" do
			let(:video) { Fabricate(:video) }
			before { set_current_user }
			
			context "when video is not queued" do
				it "creates a queue_item record" do
					post :create, video_id: video.id
					expect(QueueItem.count).to eq 1
				end
				
				it "creates a queue_item associated with a user" do
					post :create, video_id: video.id
					expect(current_user.queue_items.count).to eq 1
				end
				
				it "creates a queue_item associated with a video" do
					post :create, video_id: video.id
					expect(QueueItem.first.video).to eq video
				end
				
				it "redirects to queue page" do
					post :create, video_id: video.id
					expect(response).to redirect_to queue_items_path
				end
				
				it "creates a queue_item with a position" do
					post :create, video_id: video.id
					expect(QueueItem.first.position).to eq 1
				end
			end
			
			context "when video is already queued" do
				it "does not create a queue record" do
					queue_item = Fabricate(:queue_item, video_id: video.id, user_id: current_user.id)
					post :create, video_id: video.id
					expect(QueueItem.count).to eq 1
				end

				it "displays a flash notice" do
					queue_item = Fabricate(:queue_item, video_id: video.id, user_id: current_user.id)
					post :create, video_id: video.id
					expect(flash[:notice]).to eq "Video is already in your queue."
				end

				it "renders video page" do
					queue_item = Fabricate(:queue_item, video_id: video.id, user_id: current_user.id)
					post :create, video_id: video.id
					expect(response).to redirect_to video_path(video.id)
				end
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { post :create }
		end
	end
end