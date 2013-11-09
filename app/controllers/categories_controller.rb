class CategoriesController < ApplicationController
	before_action :require_authentication, only: [:index, :show]

	def index
		@categories = CategoryDecorator.decorate_collection(Category.all)
	end

	def show
		@category = Category.find_by(id: params[:id]).decorate
	end
end