class User < ActiveRecord::Base
	has_secure_password validations: false
	
	has_many :reviews
	has_many :queue_items
	has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
	has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
	has_many :invitations

	validates :email, presence: true, uniqueness: true
	validates :full_name, presence: true
	validates :password, presence: true, length: { minimum: 6 }

	before_create :generate_token

	def generate_new_token
		self.update_attributes(token: SecureRandom.urlsafe_base64)
	end

private
	def generate_token
		self.token = SecureRandom.urlsafe_base64
	end
end