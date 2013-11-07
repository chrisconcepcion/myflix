class Video < ActiveRecord::Base
	validates :title, presence: true
	validates :description, presence: true
	validates :small_cover_url, presence: true
	validates :large_cover_url, presence: true

	belongs_to :category

	def self.search_by_title(keyword)
		if keyword.blank?
			[]
		else
			Video.where("title LIKE ?", "%#{keyword}%").order('created_at DESC')
		end
	end

end