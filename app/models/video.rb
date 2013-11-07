class Video < ActiveRecord::Base
	validates :title, presence: true
	validates :description, presence: true
	validates :small_cover_url, presence: true
	validates :large_cover_url, presence: true

	belongs_to :category
end