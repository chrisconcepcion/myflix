class User < ActiveRecord::Base
	has_secure_password validations: false
	
	has_many :reviews
	has_many :queue_items
	has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
	has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
	
	validates :email, presence: true, uniqueness: true
	validates :full_name, presence: true
	validates :password, presence: true, length: { minimum: 6 }
end