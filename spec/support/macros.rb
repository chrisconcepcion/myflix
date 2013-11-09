def set_current_user(user = nil)
	if user == nil
		user = Fabricate(:user)
	end
	session[:user_id] = user.id
end