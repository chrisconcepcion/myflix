Fabricator(:video) do
	title { Faker::Name.name }
	description { Faker::Name.name }
	small_cover { Faker::Name.name }
	large_cover { Faker::Name.name }
end