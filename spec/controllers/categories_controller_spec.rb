require 'spec_helper'

describe CategoriesController do
	describe "GET index" do
		context "when authenticated" do
			it "is being decorated" do
				set_current_user
				category = Fabricate(:category)
				get :index
				expect(assigns(:categories)).to eq (CategoryDecorator.decorate([category])) 
			end

			it "sets categories variable" do
				set_current_user
				category1 = Fabricate(:category)
				category2 = Fabricate(:category)
				get :index
				expect(assigns(:categories)).to match_array([category1, category2])
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :index }
		end
	end

	describe "GET show" do
		let(:category) { Fabricate(:category) }

		context "when authenticated" do
			it "is being decorated" do
				set_current_user
				get :show, id: category.id
				expect(assigns(:category)).to be_decorated_with CategoryDecorator
			end

			it "sets category variable" do
				set_current_user
				get :show, id: category.id
				expect(assigns(:category)).to eq category
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :show, id: category.id }
		end
	end
end