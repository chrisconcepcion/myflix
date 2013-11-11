class User < ActiveRecord::Base
	has_secure_password validations: false
	
	has_many :reviews
	has_many :queue_items
	
	validates :email, presence: true, uniqueness: true
	validates :full_name, presence: true
	validates :password, presence: true, length: { minimum: 6 }
end