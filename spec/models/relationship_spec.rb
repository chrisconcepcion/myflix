require 'spec_helper'

describe Relationship do
	it { should belong_to(:follower) }
	it { should belong_to(:leader) }
	it { should validate_presence_of(:leader_id) }
	it { should validate_presence_of(:follower_id) }
	it { should validate_uniqueness_of(:follower_id).scoped_to(:leader_id) }
end