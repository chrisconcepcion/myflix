class User < ActiveRecord::Base
	has_secure_password validations: false

	validates :email, presence: true
	validates :full_name, presence: true
	validates :password, presence: true, length: { minimum: 6 }
end