Fabricator(:user) do
	email Faker::Internet.email
	full_name Faker::Name.name
	password Faker::Name.name
end