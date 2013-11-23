class Invitation < ActiveRecord::Base
 belongs_to :user

 validates_presence_of(:user_id)
 validates_presence_of(:recipient_email)
 before_create :generate_token

private
	def generate_token
		self.invitation_token = SecureRandom.urlsafe_base64
	end
end