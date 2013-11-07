class Friendship
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include ActiveModel::Validations



  belongs_to :follower, :class_name =>"User"
  belongs_to :followee, :class_name => "User"

  field :pending, :type => Boolean, :default => true













end