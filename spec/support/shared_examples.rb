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