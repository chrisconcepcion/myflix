class User < ActiveRecord::Base
	include Tokenable
	has_secure_password validations: false
	
	has_many :reviews
	has_many :queue_items
	has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
	has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
	has_many :invitations
	has_many :payments
	validates :email, presence: true, uniqueness: true
	validates :full_name, presence: true
	validates :password, presence: true, length: { minimum: 6 }


	def generate_new_token
		self.update_attributes(token: SecureRandom.urlsafe_base64)
	end

	def deactivate!
		update_column(:active, false)
	end
end