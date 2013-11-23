require 'spec_helper'

describe Admin::VideosController do
	describe "GET new" do
		context "when authenticated" do
			context "when admin" do
				before { set_admin }

				it "sets video variable to new record" do
					get :new
					expect(assigns(:video)).to be_a_new(Video)
				end
			end

			context "when user is not admin" do
				before { set_current_user }
				it_behaves_like "when user is not admin" do
					let(:action) { get :new }
				end
			end
		end
		context "when not authenticated" do	
			it_behaves_like "when not authenticated" do
				let(:action) { get :new }
			end
		end
	end

	describe "POST create" do
		context "when authenticated" do
			context "when admin" do
				let(:category) { Fabricate(:category) }
				before { set_admin }
				context "with valid inputs" do
					it "creates a new video record" do
						post :create, video: Fabricate.attributes_for(:video, category_id: category.id)
						expect(Video.count).to eq 1
					end	

					it "creates a video associated with a category" do
						post :create, video: Fabricate.attributes_for(:video, category_id: category.id)
						expect(Video.first.category).to eq category
					end

					it "displays a flash notice" do
						post :create, video: Fabricate.attributes_for(:video, category_id: category.id)
						expect(flash[:notice]).to eq "Video has been successfully added."
					end

					it "redirects to add a video page" do
						post :create, video: Fabricate.attributes_for(:video, category_id: category.id)
						expect(response).to redirect_to new_admin_video_path
					end
				end

				context "with invalid inputs" do
					it "doesn't create a video" do
						post :create, video: { title: "invalid"}
						expect(Video.count).to eq 0
					end
					
					it "renders new template" do
						post :create, video: { title: "invalid"}
						expect(response).to render_template :new
					end
				end 
			end

			context "when user is not admin" do
				before { set_current_user }
				it_behaves_like "when user is not admin" do
					let(:action) { post :create }
				end
			end
		end
		context "when not authenticated" do	
			it_behaves_like "when not authenticated" do
				let(:action) { post :create }
			end
		end
	end
end