def set_current_user(user = nil)
	if user == nil
		user = Fabricate(:user)
	end
	session[:user_id] = user.id
end

def current_user
	set_current_user if session[:user_id] == nil
	User.find_by(session[:user_id])
end