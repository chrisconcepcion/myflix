require 'spec_helper'

describe CategoriesController do
	describe "GET index" do
		context "when authenticated" do
			it "is being decorated" do
				set_current_user
				test_category1 = Fabricate(:category)
				get :index
				expect(assigns(:categories)).to eq (CategoryDecorator.decorate([test_category1])) 
			end

			it "sets categories variable" do
				set_current_user
				test_category1 = Fabricate(:category)
				test_category2 = Fabricate(:category)
				get :index
				expect(assigns(:categories)).to match_array([test_category1, test_category2])
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :index }
		end
	end

	describe "GET show" do
		let(:test_category) { Fabricate(:category) }

		context "when authenticated" do
			it "is being decorated" do
				set_current_user
				get :show, id: test_category.id
				expect(assigns(:category)).to be_decorated_with CategoryDecorator
			end

			it "sets category variable" do
				set_current_user
				get :show, id: test_category.id
				expect(assigns(:category)).to eq test_category
			end
		end

		it_behaves_like "when not authenticated" do
			let(:action) { get :show, id: test_category.id }
		end
	end
end