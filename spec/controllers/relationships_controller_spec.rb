require 'spec_helper'

describe RelationshipsController do
	describe "GET index" do
		context "when authenticated" do
			before { set_current_user }

			it "sets the relationships variable" do
				user = Fabricate(:user)
				follower_relationship = Fabricate(:relationship, leader_id: user.id, follower_id: current_user.id )
				get :index
				expect(assigns(:relationships)).to match_array([follower_relationship])
			end

			it "decorates the relationships variable" do
				get :index
				expect(assigns(:relationships).class).to eq Draper::CollectionDecorator
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :index }
		end
	end

	describe "POST create" do
		describe "when authenticated" do
			before{ set_current_user }
			context "when not following the user" do
				it "creates a relationship" do
					user = Fabricate(:user)
					post :create, user_id: user.id
					expect(Relationship.count).to eq 1
				end

				it "creates a relationship where current_user is following the a user" do
					user = Fabricate(:user)
					post :create, user_id: user.id
					expect(current_user.following_relationships.first.leader).to eq user
				end 

				it "displays a flash notice" do
					user = Fabricate(:user)
					post :create, user_id: user.id
					expect(flash[:notice]).to eq "You are now following #{user.full_name}."
				end

				it "redirects to user page" do
					user = Fabricate(:user)
					post :create, user_id: user.id
					expect(response).to redirect_to user_path(user)
				end
			end
			context "when already following the user" do
				it "does not create a new relationship" do
					user = Fabricate(:user)
					relationship = Fabricate(:relationship, leader_id: user.id, follower_id: current_user.id)
					post :create, user_id: user.id
					expect(Relationship.count).to eq 1
				end

				it "displays a flash notice" do
					user = Fabricate(:user)
					relationship = Fabricate(:relationship, leader_id: user.id, follower_id: current_user.id)
					post :create, user_id: user.id
					expect(flash[:notice]).to eq "You are already following this user"
				end

				it "redirects to user page" do
					user = Fabricate(:user)
					relationship = Fabricate(:relationship, leader_id: user.id, follower_id: current_user.id)
					post :create, user_id: user.id
					expect(response).to redirect_to user_path(user)
				end
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { post :create, user_id: 1}
		end
	end
end