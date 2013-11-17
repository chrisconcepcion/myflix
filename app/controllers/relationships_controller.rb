class RelationshipsController < ApplicationController
before_action :require_authentication, only: [:index, :create]

	def index
		@relationships = RelationshipDecorator.decorate_collection(current_user.following_relationships)
	end

	def create
		user = User.find_by(id: params[:user_id])
		relationship = current_user.following_relationships.create(leader: user)
		if relationship.save
			flash[:notice] = "You are now following #{user.full_name}."
			redirect_to user_path(user)
		else
			flash[:notice] = "You are already following this user"
			redirect_to user_path(user)
		end
	end
end