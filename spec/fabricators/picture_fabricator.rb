Fabricator(:picture) do
  title { Faker::Lorem.words(2).join(" ") }
  location { Faker::Lorem.words(2).join(" ") }
  description { Faker::Lorem.words(2).join(" ") }
  category { Fabricate(:category) }
  represents_category { nil }
  represents_user { nil }
  image_link { File.open(Rails.root.join("public/tmp/panda.jpg")) }
end