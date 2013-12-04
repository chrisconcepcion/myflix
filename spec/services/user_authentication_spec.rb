require 'spec_helper'

describe UserAuthentication do
	describe "#authenticate" do
		context "when user and password is valid" do
			let(:user) { Fabricate(:user) }
			it "returns true" do
				result = UserAuthentication.new(user).authenticate(user.password)
				expect(result).to eq true
			end
		end

		context "when user is inactive" do
			let(:inactive_user) { Fabricate(:user, active: false) }

			it "returns false" do
				result = UserAuthentication.new(inactive_user).authenticate(inactive_user.password)
				expect(result).to eq false
			end
			it "sets error_message variable" do
				authentication = UserAuthentication.new(inactive_user)
				authentication.authenticate(inactive_user.password)
				expect(authentication.error_message).to eq "Your account is locked, please contact customer service to resolve the issue."
			end
		end
		context "with invalid input" do
			it "returns false" do
				result = UserAuthentication.new(nil).authenticate("")
				expect(result).to eq false
			end

			it "sets error_message variable" do
				authentication = UserAuthentication.new(nil)
				authentication.authenticate("")
				expect(authentication.error_message).to eq "Incorrect email or password. Please try again."
			end
		end
	end
end