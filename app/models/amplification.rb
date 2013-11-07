class Amplification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip


  belongs_to :user
  belongs_to :shout

  field :score,				:type => Integer, :default => 1

  

  end


