class AdminsController < AuthenticatedController
	before_action :require_admin

	def require_admin
		unless current_user.admin?
			flash[:error] = "You are not authorized to perform this action."
			redirect_to root_path
		end
	end
end