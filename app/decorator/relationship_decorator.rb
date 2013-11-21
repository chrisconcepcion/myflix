class RelationshipDecorator < Draper::Decorator
	delegate_all

	def leader_total_queue_items
		leader.queue_items.count
	end

	def leader_total_followers
		leader.leading_relationships.count
	end

	def leader_email
		leader.email
	end

	def leader_name
		leader.full_name
	end
end