# spec/factories/shouts.rb

require 'faker'
require 'random'
require 'sentence'

FactoryGirl.define do
	factory :shout do |f|
		longitude = -73.5
		latitude = 45.5
		radius = 100
		f.geoloc { Random.new.location(latitude,longitude,radius) }
		
		f.content { Sentence.new.make }
		
	end
end

