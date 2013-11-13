class QueueItemsController < ApplicationController
<<<<<<< HEAD
	before_action :require_authentication, only: [:index, :create, :destroy, :update_queue]
=======
	before_action :require_authentication, only: [:index, :create, :destroy]
>>>>>>> 09404104c3597ebe5b056bf93fe6d7a0672442a4

	def index
		@queue_items = QueueItemDecorator.decorate_collection(current_user.queue_items.order("position ASC"))
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
<<<<<<< HEAD
=======
		
>>>>>>> 09404104c3597ebe5b056bf93fe6d7a0672442a4
		queue_item = current_user.queue_items.find_by(id: params[:id])
		if queue_item.greatest_position?
			queue_item.destroy
		else
			queue_item.destroy
			QueueItem.reorder_queue(current_user)
		end
		redirect_to my_queue_path
	end

<<<<<<< HEAD
	def update_queue
		queue_items = params[:queue_item]
		if queue_items.uniq {|e| e[:position] } == queue_items && queue_items.detect { |f| f[:position].to_i == 0} == nil
			queue_items.each do |q|
				current_user.queue_items.find_by(id: q[:id]).update_attributes(position: q[:position])
			end
			QueueItem.reorder_queue(current_user)
			redirect_to my_queue_path
		else
			flash[:notice] = "List order only can contain numbers and each video must have a unique number."
			redirect_to my_queue_path
		end
	end

=======
>>>>>>> 09404104c3597ebe5b056bf93fe6d7a0672442a4
end 