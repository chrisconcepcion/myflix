require 'spec_helper'

describe CategoriesController do
	describe "GET index" do
		it "sets categories variable" do
			test_category1 = Fabricate(:category)
			test_category2 = Fabricate(:category)
			get :index
			expect(assigns(:categories)).to match_array([test_category1, test_category2])
		end
	end

	describe "GET show" do
		it "sets category variable" do
			test_category = Fabricate(:category)
			get :show, id: test_category.id
			expect(assigns(:category)).to eq test_category
		end
	end
end