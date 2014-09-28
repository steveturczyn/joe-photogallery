# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Category.delete_all
Picture.delete_all

User.create(email: "joe@joelevinger.com", password: "joelevinger", name: "Joe Levinger")
User.create(email: "steve.turczyn@gotealeaf.com", password: "steveturczyn", name: "Steve Turczyn")

c1 = Category.create(name: "Wildlife", user_id: 1)
c2 = Category.create(name: "Abstractions", user_id: 1)
c3 = Category.create(name: "Flowers", user_id: 1)
c4 = Category.create(name: "Nature", user_id: 1)

c5 = Category.create(name: "Wildlife", user_id: 2)
c6 = Category.create(name: "Architecture", user_id: 2)

Picture.create(title: "Panda", location: "Washington, DC", description: "A hungry panda", image_link: File.open(Rails.root.join('public/tmp/panda.jpg')), represent_category: true, represent_user: false, category: c1)
Picture.create(title: "Florida Bird", location: "Fort Pierce, FL", description: "Beautiful bird, shot with a 400 mm zoom lens", image_link: File.open(Rails.root.join('public/tmp/bird.jpg')), represent_category: false, represent_user: false, category: c1)
Picture.create(title: "Silhouetted Bird", location: "Vero Beach, FL", description: "A silhouette of a bird", image_link: File.open(Rails.root.join('public/tmp/birdsilhouette.jpg')), represent_category: false, represent_user: false, category: c1)
Picture.create(title: "Monkeys", location: "Washington, DC", description: "Hungry monkeys", image_link: File.open(Rails.root.join('public/tmp/monkeys.jpg')), represent_category: false, represent_user: false, category: c1)
Picture.create(title: "Tigers", location: "Washington, DC", description: "Hungry tigers", image_link: File.open(Rails.root.join('public/tmp/tigers.jpg')), represent_category: false, represent_user: false, category: c1)
Picture.create(title: "Chameleon", location: "Cambridge, MA", description: "Taking a stroll", image_link: File.open(Rails.root.join('public/tmp/chameleon.jpg')), represent_category: false, represent_user: false, category: c1)

Picture.create(title: "Blue Sky", location: "Sleepy Hollow, NY", description: "Shot from a car at dusk", image_link: File.open(Rails.root.join('public/tmp/skyblue.jpg')), represent_category: true, represent_user: false, category: c2)
Picture.create(title: "Fireworks", location: "Sleepy Hollow, NY", description: "Christmas tree lights with zoom effect", image_link: File.open(Rails.root.join('public/tmp/fireworks.jpg')), represent_category: false, represent_user: false, category: c2)
Picture.create(title: "Wave", location: "Vero Beach, FL", description: "Wave with a long shutter speed", image_link: File.open(Rails.root.join('public/tmp/wave.jpg')), represent_category: false, represent_user: false, category: c2)
Picture.create(title: "Red Sky", location: "Sleepy Hollow, NY", description: "Shot from a car as the sun was setting", image_link: File.open(Rails.root.join('public/tmp/skyred.jpg')), represent_category: false, represent_user: false, category: c2)
Picture.create(title: "Stained Glass I", location: "Boston, MA", description: "Detail from Chihuly's Persian Ceiling", image_link: File.open(Rails.root.join('public/tmp/stainedglass1.jpg')), represent_category: false, represent_user: false, category: c2)
Picture.create(title: "Stained Glass II", location: "Boston, MA", description: "Detail of Chihuly glassware", image_link: File.open(Rails.root.join('public/tmp/stainedglass2.jpg')), represent_category: false, represent_user: false, category: c2)

Picture.create(title: "Goldenrod", location: "Truro, MA", description: "A hungry bee", image_link: File.open(Rails.root.join('public/tmp/goldenrod.jpg')), represent_category: true, represent_user: true, category: c3)
Picture.create(title: "Magnolia", location: "Boston, MA", description: "A magnolia, in full bloom, from the Arnold Arboretum", image_link: File.open(Rails.root.join('public/tmp/magnolia.jpg')), represent_category: false, represent_user: false, category: c3)
Picture.create(title: "Iris", location: "Washington, DC", description: "An iris, after the rain", image_link: File.open(Rails.root.join('public/tmp/iris.jpg')), represent_category: false, represent_user: false, category: c3)
Picture.create(title: "Rose", location: "Washington, DC", description: "A rose, after the rain", image_link: File.open(Rails.root.join('public/tmp/rose.jpg')), represent_category: false, represent_user: false, category: c3)
Picture.create(title: "Lupine", location: "Bar Harbor, ME", description: "Lupines at Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lupine.jpg')), represent_category: false, represent_user: false, category: c3)
Picture.create(title: "Rhododendron", location: "Boston, MA", description: "A rhododendron, about to bloom", image_link: File.open(Rails.root.join('public/tmp/rhododendron.jpg')), represent_category: false, represent_user: false, category: c3)

Picture.create(title: "The Knob", location: "Falmouth, MA", description: "A sunset on the East Coast", image_link: File.open(Rails.root.join('public/tmp/theknob.jpg')), represent_category: true, represent_user: false, category: c4)
Picture.create(title: "Ocean", location: "Fort Pierce, FL", description: "Atlantic Ocean, shot with a 10 mm ultra wide-ange lens", image_link: File.open(Rails.root.join('public/tmp/ocean.jpg')), represent_category: false, represent_user: false, category: c4)
Picture.create(title: "Tree Reflection", location: "Vero Beach, FL", description: "A reflection of a palm tree", image_link: File.open(Rails.root.join('public/tmp/treereflection.jpg')), represent_category: false, represent_user: false, category: c4)
Picture.create(title: "Fern", location: "Boston, MA", description: "Ferns look beautiful in the early spring", image_link: File.open(Rails.root.join('public/tmp/fern.jpg')), represent_category: false, represent_user: false, category: c4)
Picture.create(title: "Lichen", location: "Bar Harbor, ME", description: "From the summit of Cadillac Mountain, in Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lichen.jpg')), represent_category: false, represent_user: false, category: c4)
Picture.create(title: "Lake Reflection", location: "Bar Harbor, ME", description: "A lake at Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lakereflection.jpg')), represent_category: false, represent_user: false, category: c4)

Picture.create(title: "Deer", location: "Newport, RI", description: "Deer at dawn", image_link: File.open(Rails.root.join('public/tmp/deer.jpg')), represent_category: true, represent_user: true, category: c5)
Picture.create(title: "Rabbit", location: "Truro, MA", description: "Bunny Rabbit", image_link: File.open(Rails.root.join('public/tmp/rabbit.jpg')), represent_category: false, represent_user: false, category: c5)

Picture.create(title: "Chandelier 1", location: "Boston, MA", description: "A pretty chandelier", image_link: File.open(Rails.root.join('public/tmp/chandelier1.jpg')), represent_category: true, represent_user: false, category: c6)
Picture.create(title: "Chandelier 2", location: "Boston, MA", description: "Another pretty chandelier", image_link: File.open(Rails.root.join('public/tmp/chandelier2.jpg')), represent_category: false, represent_user: false, category: c6)