class QueueItemsController < ApplicationController
	before_action :require_authentication, only: [:index, :create, :destroy]

	def index
		@queue_items = QueueItemDecorator.decorate_collection(current_user.queue_items)
	end

	def create
		video = Video.find_by(id: params[:video_id])
		queue_item = current_user.queue_items.create(video_id: video.id)
		if queue_item.save
			queue_item.create_position
			redirect_to my_queue_path
		else
			flash[:notice] = "Video is already in your queue."
			redirect_to video_path(video)
		end
	end

	def destroy
		
		queue_item = current_user.queue_items.find_by(id: params[:id])
		if queue_item.greatest_position?
			queue_item.destroy
		else
			queue_item.destroy
			QueueItem.reorder_queue(current_user)
		end
		redirect_to my_queue_path
	end

end 