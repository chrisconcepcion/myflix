Fabricator(:video) do
	title Faker::Name.name
	description Faker::Name.name
	small_cover_url Faker::Name.name
	large_cover_url Faker::Name.name
end