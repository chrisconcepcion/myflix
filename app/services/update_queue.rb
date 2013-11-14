class UpdateQueue

	def initialize(user)
		@user = user
	end

	def update_queue(update_hash)
		if validate_update_hash?(update_hash)
			update_queue_ratings_and_positions(update_hash)
			QueueItem.reorder_queue(@user)
			true
		else
			false
		end
	end

private
	def validate_update_hash?(update_hash)
		#returns true if all positions are unique and are integers
		update_hash.uniq {|queue_item| queue_item[:position] } == update_hash && update_hash.detect { |queue_item| queue_item[:position].to_i == 0} == nil
	end

	def update_queue_ratings_and_positions(update_hash)
		update_hash.each do |queue_item|
			@user.queue_items.find_by(id: queue_item[:id]).update_attributes(position: queue_item[:position])
			reviews = @user.reviews.find_by(video_id: (QueueItem.find(queue_item[:id]).video_id))
			if reviews
				reviews.update_attributes(rating: queue_item[:rating])
			else
				@user.reviews.create(video_id: QueueItem.find(queue_item[:id]).video_id, rating: queue_item[:rating])
			end
		end
	end
end