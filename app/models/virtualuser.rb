class Virtualuser
	include Mongoid::Document
  	include Mongoid::Timestamps


  	has_and_belongs_to_many :notes

  	field :email,				:type => String, :default => ""
  	field :phone_number,		:type => String, :default => ""

end
  