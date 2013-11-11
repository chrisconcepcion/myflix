class QueueItemsController < ApplicationController
	before_action :require_authentication, only: [:index, :create]

	def index
		@queue_items = QueueItemDecorator.decorate_collection(current_user.queue_items)
	end

	def create
		queue_item = current_user.queue_items.create(video_id: params[:video_id])
		if queue_item.save
			queue_item.create_position
			redirect_to queue_items_path
		else
			flash[:notice] = "Video is already in your queue."
			redirect_to video_path(params[:video_id])
		end
	end
end 