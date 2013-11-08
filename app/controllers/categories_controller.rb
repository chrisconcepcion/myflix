class CategoriesController < ApplicationController
	def index
		@categories = CategoryDecorator.decorate_collection(Category.all)
	end

	def show
		@category = Category.find_by(id: params[:id]).decorate
	end
end