class VideosController < ApplicationController
	before_action :require_authentication, only: [:show, :search]

	def show
		@video = Video.find_by(id: params[:id])
	end

	def search
		@search = Video.search_by_title(params[:keyword])
		@keyword = params[:keyword]
		if @search == []
			flash[:notice] = "No videos have been found."
		end
	end
end