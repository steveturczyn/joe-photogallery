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
c2 = Category.create(name: "Abstractions")
c3 = Category.create(name: "Flowers")
c4 = Category.create(name: "Nature")

Image.create(title: "Florida Bird", location: "Fort Pierce, FL", description: "Beautiful bird, shot with a 400 mm zoom lens", image_link: File.open(Rails.root.join('public/tmp/bird.jpg')), home: false, category: c1)
Image.create(title: "Panda", location: "Washington, DC", description: "A hungry panda", image_link: File.open(Rails.root.join('public/tmp/panda.jpg')), home: true, category: c1)
Image.create(title: "Silhouetted Bird", location: "Vero Beach, FL", description: "A silhouette of a bird", image_link: File.open(Rails.root.join('public/tmp/birdsilhouette.jpg')), home: false, category: c1)
Image.create(title: "Monkeys", location: "Washington, DC", description: "Hungry monkeys", image_link: File.open(Rails.root.join('public/tmp/monkeys.jpg')), home: false, category: c1)
Image.create(title: "Tigers", location: "Washington, DC", description: "Hungry tigers", image_link: File.open(Rails.root.join('public/tmp/tigers.jpg')), home: false, category: c1)
Image.create(title: "Chameleon", location: "Cambridge, MA", description: "Taking a stroll", image_link: File.open(Rails.root.join('public/tmp/chameleon.jpg')), home: false, category: c1)

Image.create(title: "Blue Sky", location: "Sleepy Hollow, NY", description: "Shot from a car at dusk", image_link: File.open(Rails.root.join('public/tmp/skyblue.jpg')), home: true, category: c2)
Image.create(title: "Fireworks", location: "Sleepy Hollow, NY", description: "Christmas tree lights with zoom effect", image_link: File.open(Rails.root.join('public/tmp/fireworks.jpg')), home: false, category: c2)
Image.create(title: "Wave", location: "Vero Beach, FL", description: "Wave with a long shutter speed", image_link: File.open(Rails.root.join('public/tmp/wave.jpg')), home: false, category: c2)
Image.create(title: "Red Sky", location: "Sleepy Hollow, NY", description: "Shot from a car as the sun was setting", image_link: File.open(Rails.root.join('public/tmp/skyred.jpg')), home: false, category: c2)
Image.create(title: "Stained Glass I", location: "Boston, MA", description: "Detail from Chihuly's Persian Ceiling", image_link: File.open(Rails.root.join('public/tmp/stainedglass1.jpg')), home: false, category: c2)
Image.create(title: "Blue Sky", location: "Boston, MA", description: "Detail of Chihuly glassware", image_link: File.open(Rails.root.join('public/tmp/stainedglass2.jpg')), home: false, category: c2)

Image.create(title: "Goldenrod", location: "Truro, MA", description: "A hungry bee", image_link: File.open(Rails.root.join('public/tmp/goldenrod.jpg')), home: true, category: c3)
Image.create(title: "Magnolia", location: "Boston, MA", description: "A magnolia, in full bloom, from the Arnold Arboretum", image_link: File.open(Rails.root.join('public/tmp/magnolia.jpg')), home: false, category: c3)
Image.create(title: "Iris", location: "Washington, DC", description: "An iris, after the rain", image_link: File.open(Rails.root.join('public/tmp/iris.jpg')), home: false, category: c3)
Image.create(title: "Rose", location: "Washington, DC", description: "A rose, after the rain", image_link: File.open(Rails.root.join('public/tmp/rose.jpg')), home: false, category: c3)
Image.create(title: "Lupine", location: "Bar Harbor, ME", description: "Lupines at Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lupine.jpg')), home: false, category: c3)
Image.create(title: "Rhododendron", location: "Boston, MA", description: "A rhododendron, about to bloom", image_link: File.open(Rails.root.join('public/tmp/rhododendron.jpg')), home: false, category: c3)

Image.create(title: "The Knob", location: "Falmouth, MA", description: "A sunset on the East Coast", image_link: File.open(Rails.root.join('public/tmp/theknob.jpg')), home: true, category: c4)
Image.create(title: "Ocean", location: "Fort Pierce, FL", description: "Atlantic Ocean, shot with a 10 mm ultra wide-ange lens", image_link: File.open(Rails.root.join('public/tmp/ocean.jpg')), home: false, category: c4)
Image.create(title: "Tree Reflection", location: "Vero Beach, FL", description: "A reflection of a palm tree", image_link: File.open(Rails.root.join('public/tmp/treereflection.jpg')), home: false, category: c4)
Image.create(title: "Fern", location: "Boston, MA", description: "Ferns look beautiful in the early spring", image_link: File.open(Rails.root.join('public/tmp/fern.jpg')), home: false, category: c4)
Image.create(title: "Lichen", location: "Bar Harbor, ME", description: "From the summit of Cadillac Mountain, in Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lichen.jpg')), home: false, category: c4)
Image.create(title: "Lake Reflection", location: "Bar Harbor, ME", description: "A lake at Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lakereflection.jpg')), home: false, category: c4)