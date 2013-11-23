require 'spec_helper'

describe Invitation do
	it { should belong_to(:user) }
	it { should validate_presence_of(:recipient_email) }
	it { should validate_presence_of(:user_id) }

	it "generates an invitation token upon creation" do
		user = Fabricate(:user)
		invitation = Fabricate(:invitation, user_id: user.id)
		expect(invitation.reload.invitation_token).to be_present
	end
end