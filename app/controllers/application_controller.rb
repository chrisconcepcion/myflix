class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user


  def current_user
  	User.find(session[:user_id]) if session[:user_id]
  end

  def already_authenticated
  	redirect_to home_path if current_user
  end

  def require_authentication
  	if current_user == nil
			flash[:notice] = "Only authenticated users can preform this action, please sign in."
			redirect_to sign_in_path
		end
	end
  
end
