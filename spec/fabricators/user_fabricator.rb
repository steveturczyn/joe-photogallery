Fabricator(:user) do
  first_name { Faker::Lorem.words(1) }
  last_name { Faker::Lorem.words(1) }
  email { Faker::Internet.email }
  password 'password'
end