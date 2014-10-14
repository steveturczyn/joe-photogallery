Fabricator(:category) do
  name { Faker::Lorem.words(2).join(" ") }
  user_id { Faker::Number.digit }
end