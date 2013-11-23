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
end