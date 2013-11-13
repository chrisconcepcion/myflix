require 'spec_helper'

describe QueueItemsController do 
	describe "GET index" do
		context "when authenicated" do
			before { set_current_user }

			it "sets the queue_items variable" do
				video1 = Fabricate(:video)
				video2 = Fabricate(:video)
				queue_item1 = Fabricate(:queue_item, position: 1, video_id: video1.id, user_id: current_user.id)
				queue_item2 = Fabricate(:queue_item, position: 2, video_id: video2.id, user_id: current_user.id)
				get :index
				expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
			end

			it "decorators queue_items variable" do
				video1 = Fabricate(:video)
				video2 = Fabricate(:video)
				queue_item1 = Fabricate(:queue_item, position: 1, video_id: video1.id, user_id: current_user.id)
				queue_item2 = Fabricate(:queue_item, position: 2, video_id: video2.id, user_id: current_user.id)
				get :index
				expect(assigns(:queue_items).class).to eq Draper::CollectionDecorator
			end

			it "orders queue_items by ascending position" do
				video1 = Fabricate(:video)
				video2 = Fabricate(:video)
				video3 = Fabricate(:video)
				queue_item3 = Fabricate(:queue_item, position: 3, video_id: video3.id, user_id: current_user.id)
				queue_item1 = Fabricate(:queue_item, position: 1, video_id: video1.id, user_id: current_user.id)
				queue_item2 = Fabricate(:queue_item, position: 2, video_id: video2.id, user_id: current_user.id)		
				get :index
				expect(assigns(:queue_items)).to eq current_user.queue_items.order("position ASC")
			end
		end
		
		it_behaves_like "when not authenticated" do
			let(:action) { get :index }
		end
	end

	describe "POST create" do
		context "when authenticated" do
			let(:video) { Fabricate(:video) }
			
			context "when video is not queued" do
				before { set_current_user }

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
					expect(response).to redirect_to my_queue_path
				end
				
				it "creates a queue_item with a position" do
					post :create, video_id: video.id
					expect(QueueItem.first.position).to eq 1
				end
			end

			context "when video is already queued" do
				before { set_current_user }
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
			video = Fabricate(:video) 
			let(:action) { post :create, video_id: video.id }
		end
	end

	describe "DELETE destroy" do
		let(:user) { Fabricate(:user) }
		let(:video) { Fabricate(:video) }
		let(:queue_item) { Fabricate(:queue_item, user_id: user.id, video_id: video.id) }

		context "when authenticated" do
			let(:queue_item) { Fabricate(:queue_item, user_id: current_user.id, video_id: video.id) }
			before { set_current_user }
			
			it "destroys queue_item record" do
				delete :destroy, id: queue_item.id
				expect(QueueItem.count).to eq 0
			end
			
			it "redirects to queue page" do
				delete :destroy, id: queue_item.id
				expect(response).to redirect_to my_queue_path
			end

			context "when destroyed queue_item doesn't have the greatest position" do
				it "reorders the queue" do
					queue_item1 = Fabricate(:queue_item, position: 1, user_id: current_user.id, video_id: video.id)
					video2 = Fabricate(:video)
					queue_item2 = Fabricate(:queue_item, position: 2, user_id: current_user.id, video_id: video2.id)
					video3 = Fabricate(:video)
					queue_item3 = Fabricate(:queue_item, position: 3, user_id: current_user.id, video_id: video3.id)
					delete :destroy, id: queue_item1.id
					expect(queue_item2.reload.position).to eq 1
					expect(queue_item3.reload.position).to eq 2
				end
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { delete :destroy, id: queue_item.id}
		end
	end

	describe "POST update_queue" do
		context "when authenticated" do
			let(:video1) { Fabricate(:video) }
			let(:video2) { Fabricate(:video) }
			let(:video3) { Fabricate(:video) }
			let(:queue_item1) { Fabricate(:queue_item, user_id: current_user.id, video_id: video1.id, position: 1) }
			let(:queue_item2) { Fabricate(:queue_item, user_id: current_user.id, video_id: video2.id, position: 2) }
			let(:queue_item3) { Fabricate(:queue_item, user_id: current_user.id, video_id: video3.id, position: 3) }
			before { set_current_user }

			context "with valid inputs" do
				it "updates queue positions" do
					post :update_queue, queue_item: [ {id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 3}, {id: queue_item3.id, position: 1} ]
					expect(queue_item1.reload.position).to eq 2
					expect(queue_item2.reload.position).to eq 3
					expect(queue_item3.reload.position).to eq 1
				end

				it "reorders queue positions" do
					post :update_queue, queue_item: [ {id: queue_item1.id, position: 4}, {id: queue_item2.id, position: 5}, {id: queue_item3.id, position: 3} ]
					expect(queue_item1.reload.position).to eq 2
					expect(queue_item2.reload.position).to eq 3
					expect(queue_item3.reload.position).to eq 1
				end

				it "redirects to queue page" do
					post :update_queue, queue_item: [ {id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 3}, {id: queue_item3.id, position: 1} ]
					expect(response).to redirect_to my_queue_path
				end
			end
			context "with invalid inputs" do
				context "with non-integer inputs as positions" do
					it "does not update queue positions" do
						post :update_queue, queue_item: [ {id: queue_item1.id, position: 1}, {id: queue_item2.id, position: "coolio"}, {id: queue_item3.id, position: "lawl"} ]
						expect(queue_item1.reload.position).to eq 1
						expect(queue_item2.reload.position).to eq 2
						expect(queue_item3.reload.position).to eq 3
					end		

					it "displays a flash notice" do
						post :update_queue, queue_item: [ {id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 1}, {id: queue_item3.id, position: "lawl"} ]
						expect(flash[:notice]).to eq "List order only can contain numbers and each video must have a unique number."
					end	

					it "redirects to queue_pages" do
						post :update_queue, queue_item: [ {id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 1}, {id: queue_item3.id, position: "lawl"} ]
						expect(response).to redirect_to my_queue_path
					end
				end

				context "with non-unique integer inputs as positions" do
					it "does not update queue positions" do
						post :update_queue, queue_item: [ {id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 1}, {id: queue_item3.id, position: "lawl"} ]
						expect(queue_item1.reload.position).to eq 1
						expect(queue_item2.reload.position).to eq 2
						expect(queue_item3.reload.position).to eq 3
					end		

					it "displays a flash notice" do
						post :update_queue, queue_item: [ {id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 1}, {id: queue_item3.id, position: 2} ]
						expect(flash[:notice]).to eq "List order only can contain numbers and each video must have a unique number."
					end	

					it "redirects to queue_pages" do
						post :update_queue, queue_item: [ {id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 1}, {id: queue_item3.id, position: "lawl"} ]
						expect(response).to redirect_to my_queue_path
					end
				end
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { post :update_queue }
		end
	end



	describe "DELETE destroy" do
		let(:user) { Fabricate(:user) }
		let(:video) { Fabricate(:video) }
		let(:queue_item) { Fabricate(:queue_item, user_id: user.id, video_id: video.id) }

		context "when authenticated" do
			let(:queue_item) { Fabricate(:queue_item, user_id: current_user.id, video_id: video.id) }
			before { set_current_user }
			
			it "destroys queue_item record" do
				delete :destroy, id: queue_item.id
				expect(QueueItem.count).to eq 0
			end
			
			it "redirects to queue page" do
				delete :destroy, id: queue_item.id
				expect(response).to redirect_to my_queue_path
			end

			context "when destroyed queue_item doesn't have the greatest position" do
				it "reorders the queue" do
					queue_item1 = Fabricate(:queue_item, position: 1, user_id: current_user.id, video_id: video.id)
					video2 = Fabricate(:video)
					queue_item2 = Fabricate(:queue_item, position: 2, user_id: current_user.id, video_id: video2.id)
					video3 = Fabricate(:video)
					queue_item3 = Fabricate(:queue_item, position: 3, user_id: current_user.id, video_id: video3.id)
					delete :destroy, id: queue_item1.id
					expect(queue_item2.reload.position).to eq 1
					expect(queue_item3.reload.position).to eq 2
				end
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { delete :destroy, id: queue_item.id}
		end
	end



end