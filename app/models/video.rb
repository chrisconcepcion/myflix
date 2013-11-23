class Video < ActiveRecord::Base
	validates :title, presence: true
	validates :description, presence: true


	belongs_to :category
	has_many :reviews
	has_many :queue_items

	mount_uploader :small_cover, SmallCoverUploader
	mount_uploader :large_cover, SmallCoverUploader

	def self.search_by_title(keyword)
		if keyword.blank?
			[]
		else
			Video.where("title LIKE ?", "%#{keyword}%").order('created_at DESC')
		end
	end

end