# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


50.times do 
  		Shout.new("geoloc" => Random.new.location(41.996689,-88.125643, 1000), "content" => Sentence.new.make)
  		Shout.save
end
