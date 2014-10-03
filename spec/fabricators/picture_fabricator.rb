Fabricator(:picture) do
  title { Faker::Lorem.words(2).join(" ") }
  location { Faker::Lorem.words(2).join(" ") }
  description { Faker::Lorem.words(2).join(" ") }
  category { Fabricate(:category) }
  represent_user { true }
end