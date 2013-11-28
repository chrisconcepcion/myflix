def set_current_user(a_user = nil)
	if a_user == nil
		a_user = Fabricate(:user)
	end
	session[:user_id] = a_user.id
end

def current_user
	set_current_user if session[:user_id] == nil
	User.find_by(session[:user_id])
end

def set_admin(a_user = nil)
	if a_user == nil
		a_user = Fabricate(:admin)
		session[:user_id] = a_user.id
	end
end

def sign_in(a_user = nil)
  user = (a_user || Fabricate(:user))
  visit '/sign_in'
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def admin_sign_in
  user = Fabricate(:admin)
  visit '/sign_in'
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
	visit sign_out_path
end