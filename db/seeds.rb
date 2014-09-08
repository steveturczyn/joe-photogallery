# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Image.delete_all
Category.delete_all

c1 = Category.create(name: "Wildlife")
c2 = Category.create(name: "Architecture")
c3 = Category.create(name: "Flowers")
c4 = Category.create(name: "Nature")

Image.create(title: "Florida Bird", location: "Fort Pierce, FL", description: "Beautiful bird, shot with a 400 mm zoom lens", image_link: File.open(Rails.root.join('public/tmp/bird.jpg')), category: c1)
Image.create(title: "Opera House Detail", location: "Boston, MA", description: "Terrific chandelier", image_link: File.open(Rails.root.join('public/tmp/operahouse.jpg')), category: c2)
Image.create(title: "Rhododendron", location: "Boston, MA", description: "Beautiful flower, shot with a macro lens", image_link: File.open(Rails.root.join('public/tmp/flower.jpg')), category: c3)
Image.create(title: "Ocean", location: "Fort Pierce, FL", description: "Atlantic Ocean, shot with a 10 mm ultra wide-ange lens", image_link: File.open(Rails.root.join('public/tmp/ocean.jpg')), category: c4)