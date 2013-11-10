class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :video

	validates :rating, presence: true, inclusion: { in: 1..5 }

end