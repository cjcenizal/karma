class Comment < Shout
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip
  include ActiveModel::Validations



  belongs_to :shout
  belongs_to :user

  












end