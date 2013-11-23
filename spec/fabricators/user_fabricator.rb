Fabricator(:user) do
	email { Faker::Internet.email }
	full_name { Faker::Name.name } 
	password { Faker::Name.name }
end

Fabricator(:invalid_user, from: :user) do
	password ""
end

Fabricator(:admin, from: :user) do
	admin true
end