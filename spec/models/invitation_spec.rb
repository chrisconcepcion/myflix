require 'spec_helper'

describe Invitation do
	it { should belong_to(:user) }
	it { should validate_presence_of(:recipient_email) }
	it { should validate_presence_of(:user_id) }

	context "when an invitation is created" do
		let(:user) { Fabricate(:user) }
		it_behaves_like "tokenable" do
			let(:object) { Fabricate(:invitation, user_id: user.id) }
		end
	end
end