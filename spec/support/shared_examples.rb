shared_examples "when not authenticated" do
	it "displays a flash notice" do
		action
		expect(flash[:notice]).to eq "Only authenticated users can preform this action, please sign in." 
	end
	it "redirects to sign in page" do
		action
		expect(response).to redirect_to sign_in_path
	end
end

shared_examples "when token doesn't match a user token" do
	it "redirects to invalid token page" do
		action
		expect(response).to redirect_to invalid_token_path
	end
end


shared_examples "tokenable" do
	it "generates a random token when the object is created" do
		expect(object.token).to be_present
	end
end

shared_examples "when user is not admin" do
	it "redirects to root_path" do
		action
		expect(response).to redirect_to root_path
	end
	it "displays a flash error" do
		action
		expect(flash[:error]).to eq "You are not authorized to perform this action."
	end
end