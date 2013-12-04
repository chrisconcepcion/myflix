require 'spec_helper'

describe Admin::PaymentsController do
	describe "GET index" do
		before { set_admin }
		it "sets payments variable" do
			payment1 = Fabricate(:payment, user_id: current_user.id)
			payment2 = Fabricate(:payment, user_id: current_user.id)
			get :index
			expect(assigns(:payments)).to match_array([payment1, payment2])
		end

		it "decorates payments variable" do
			payment1 = Fabricate(:payment, user_id: current_user.id)
			payment2 = Fabricate(:payment, user_id: current_user.id)
			get :index
			expect(assigns(:payments).class).to eq Draper::CollectionDecorator
		end 
	end
end