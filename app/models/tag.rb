class Tag
  include Mongoid::Document
  field :name

  belongs_to :shout
end