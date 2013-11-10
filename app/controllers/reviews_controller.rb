class ReviewsController < ApplicationController
	before_action :require_authentication, only: [:create]

	def create
		@video = Video.find_by(id: params[:video_id])
		@review = @video.reviews.create(review_params.merge!(user_id: current_user.id))
		if @review.save
			flash[:notice] = "Your review has been posted."
			redirect_to video_path(@video)
		else
			render 'videos/show'
		end
	end

private
	def review_params
		params.require(:review).permit(:user_id, :rating, :description)
	end

end