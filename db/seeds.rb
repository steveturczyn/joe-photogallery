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

User.create(email: "joe@joelevinger.com", password: "joelevinger", first_name: "Joe", last_name: "Levinger", bio: "Joe Levinger lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

User.create(email: "steve.turczyn@gotealeaf.com", password: "steveturczyn", first_name: "Steve", last_name: "Turczyn", bio: "Steve Turczyn lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

User.create(email: "dcestari@gmail.com", password: "danielcestari", first_name: "Daniel", last_name: "Cestari", bio: "Daniel Cestari lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

c1 = Category.create(name: "Wildlife", user_id: 1)
c2 = Category.create(name: "Abstractions", user_id: 1)

c3 = Category.create(name: "Flowers", user_id: 2)
c4 = Category.create(name: "Nature", user_id: 2)

c5 = Category.create(name: "Wildlife", user_id: 3)
c6 = Category.create(name: "Architecture", user_id: 3)

Picture.create(title: "Panda", location: "Washington, DC", description: "A hungry panda", image_link: File.open(Rails.root.join('public/tmp/panda.jpg')), represents_category: c1, represents_user: c1.user, categories: [c1])
Picture.create(title: "Florida Bird", location: "Fort Pierce, FL", description: "Beautiful bird, shot with a 400 mm zoom lens", image_link: File.open(Rails.root.join('public/tmp/bird.jpg')), categories: [c1])
Picture.create(title: "Silhouetted Bird", location: "Vero Beach, FL", description: "A silhouette of a bird", image_link: File.open(Rails.root.join('public/tmp/birdsilhouette.jpg')), categories: [c1])
Picture.create(title: "Monkeys", location: "Washington, DC", description: "Hungry monkeys", image_link: File.open(Rails.root.join('public/tmp/monkeys.jpg')), categories: [c1])
Picture.create(title: "Tigers", location: "Washington, DC", description: "Hungry tigers", image_link: File.open(Rails.root.join('public/tmp/tigers.jpg')), categories: [c1])
Picture.create(title: "Chameleon", location: "Cambridge, MA", description: "Taking a stroll", image_link: File.open(Rails.root.join('public/tmp/chameleon.jpg')), categories: [c1])

Picture.create(title: "Blue Sky", location: "Sleepy Hollow, NY", description: "Shot from a car at dusk", image_link: File.open(Rails.root.join('public/tmp/skyblue.jpg')), represents_category: c2, categories: [c2])
Picture.create(title: "Fireworks", location: "Sleepy Hollow, NY", description: "Christmas tree lights with zoom effect", image_link: File.open(Rails.root.join('public/tmp/fireworks.jpg')), categories: [c2])
Picture.create(title: "Wave", location: "Vero Beach, FL", description: "Wave with a long shutter speed", image_link: File.open(Rails.root.join('public/tmp/wave.jpg')), categories: [c2])
Picture.create(title: "Red Sky", location: "Sleepy Hollow, NY", description: "Shot from a car as the sun was setting", image_link: File.open(Rails.root.join('public/tmp/skyred.jpg')), categories: [c2])
Picture.create(title: "Stained Glass I", location: "Boston, MA", description: "Detail from Chihuly's Persian Ceiling", image_link: File.open(Rails.root.join('public/tmp/stainedglass1.jpg')), categories: [c2])
Picture.create(title: "Stained Glass II", location: "Boston, MA", description: "Detail of Chihuly glassware", image_link: File.open(Rails.root.join('public/tmp/stainedglass2.jpg')), categories: [c2])

Picture.create(title: "Goldenrod", location: "Truro, MA", description: "A hungry bee", image_link: File.open(Rails.root.join('public/tmp/goldenrod.jpg')), represents_category: c3, represents_user: c3.user, categories: [c3])
Picture.create(title: "Magnolia", location: "Boston, MA", description: "A magnolia, in full bloom, from the Arnold Arboretum", image_link: File.open(Rails.root.join('public/tmp/magnolia.jpg')), categories: [c3])
Picture.create(title: "Iris", location: "Washington, DC", description: "An iris, after the rain", image_link: File.open(Rails.root.join('public/tmp/iris.jpg')), categories: [c3])
Picture.create(title: "Rose", location: "Washington, DC", description: "A rose, after the rain", image_link: File.open(Rails.root.join('public/tmp/rose.jpg')), categories: [c3])
Picture.create(title: "Lupine", location: "Bar Harbor, ME", description: "Lupines at Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lupine.jpg')), categories: [c3])
Picture.create(title: "Rhododendron", location: "Boston, MA", description: "A rhododendron, about to bloom", image_link: File.open(Rails.root.join('public/tmp/rhododendron.jpg')), categories: [c3])

Picture.create(title: "The Knob", location: "Falmouth, MA", description: "A sunset on the East Coast", image_link: File.open(Rails.root.join('public/tmp/theknob.jpg')), represents_category: c4, categories: [c4])
Picture.create(title: "Ocean", location: "Fort Pierce, FL", description: "Atlantic Ocean, shot with a 10 mm ultra wide-ange lens", image_link: File.open(Rails.root.join('public/tmp/ocean.jpg')), categories: [c4])
Picture.create(title: "Tree Reflection", location: "Vero Beach, FL", description: "A reflection of a palm tree", image_link: File.open(Rails.root.join('public/tmp/treereflection.jpg')), categories: [c4])
Picture.create(title: "Fern", location: "Boston, MA", description: "Ferns look beautiful in the early spring", image_link: File.open(Rails.root.join('public/tmp/fern.jpg')), categories: [c4])
Picture.create(title: "Lichen", location: "Bar Harbor, ME", description: "From the summit of Cadillac Mountain, in Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lichen.jpg')), categories: [c4])
Picture.create(title: "Lake Reflection", location: "Bar Harbor, ME", description: "A lake at Acadia National Park", image_link: File.open(Rails.root.join('public/tmp/lakereflection.jpg')), categories: [c4])

Picture.create(title: "Deer", location: "Newport, RI", description: "Deer at dawn", image_link: File.open(Rails.root.join('public/tmp/deer.jpg')), represents_category: c5, represents_user: c5.user, categories: [c5])
Picture.create(title: "Rabbit", location: "Truro, MA", description: "Bunny Rabbit", image_link: File.open(Rails.root.join('public/tmp/rabbit.jpg')), categories: [c5])

Picture.create(title: "Chandelier 1", location: "Boston, MA", description: "A pretty chandelier", image_link: File.open(Rails.root.join('public/tmp/chandelier1.jpg')), represents_category: c6, categories: [c6])
Picture.create(title: "Chandelier 2", location: "Boston, MA", description: "Another pretty chandelier", image_link: File.open(Rails.root.join('public/tmp/chandelier2.jpg')), categories: [c6])