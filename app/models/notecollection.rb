class Notecollection
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  

  has_many :notes


  field :notes_list,			:type => Array, :default => []




end