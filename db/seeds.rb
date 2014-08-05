# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Image.delete_all

Image.create(title: "Florida Bird", location: "Fort Pierce, FL", description: "Beautiful bird, shot with a 400 mm zoom lens", url_sm: File.open(Rails.root.join('public/tmp/bird_sm.jpg')), url_lg: File.open(Rails.root.join('public/tmp/bird_lg.jpg')), category_id: 1)
Image.create(title: "Opera House Detail", location: "Boston, MA", description: "Terrific chandelier", url_sm: File.open(Rails.root.join('public/tmp/operahouse_sm.jpg')), url_lg: File.open(Rails.root.join('public/tmp/operahouse_lg.jpg')), category_id: 2)
Image.create(title: "Rhododendron", location: "Boston, MA", description: "Beautiful flower, shot with a macro lens", url_sm: File.open(Rails.root.join('public/tmp/flower_sm.jpg')), url_lg: File.open(Rails.root.join('public/tmp/flower_lg.jpg')), category_id: 3)
Image.create(title: "Ocean", location: "Fort Pierce, FL", description: "Atlantic Ocean, show with a 10 mm ultra wide-ange lens", url_sm: File.open(Rails.root.join('public/tmp/ocean_sm.jpg')), url_lg: File.open(Rails.root.join('public/tmp/ocean_lg.jpg')), category_id: 4)