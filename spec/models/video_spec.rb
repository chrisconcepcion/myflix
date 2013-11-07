require 'spec_helper'

describe Video do
	it { should validate_presence_of(:title) }
	it { should validate_presence_of(:description) }
	it { should validate_presence_of(:small_cover_url) }
	it { should validate_presence_of(:large_cover_url)}
end