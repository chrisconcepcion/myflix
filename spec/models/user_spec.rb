require 'spec_helper'

describe User do
	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email) }
	it { should validate_presence_of(:password) }
	it { should ensure_length_of(:password).is_at_least(6) }
	it { should validate_presence_of(:full_name) }
	it { should have_many(:reviews) }
	it { should have_many(:queue_items) }
	it { should have_many(:leading_relationships) }
	it { should have_many(:following_relationships) }

	
	it "generates a random token when a user is created" do
		user = Fabricate(:user)
		expect(user.token).to be_present
	end

	describe "#generate_new_token" do
		it "generates a new token for a user" do
			user = Fabricate(:user)
			old_token = user.token
			user.generate_new_token
			expect(user.reload.token).to_not eq old_token
		end
	end
end