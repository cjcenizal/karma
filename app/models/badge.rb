class Badge
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  has_and_belongs_to_many :users

  
  # field :tournament_id,		:type => Integer
  field :name,				:type => String, :default => ""
  field :type,        :type => String

  IMAGE_SIZES = { :standard => "212x207>" }    
  IMAGE_SIZES_GREY = { :standard => "212x207>" }  
  IMAGE_SIZES_SMALL = { :small => "212x207>" }
  
  has_mongoid_attached_file :badge_pic, :styles => IMAGE_SIZES,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":class/:id/:style.:extension",
    :bucket => "badge_pics_#{Rails.env}",  
    :default_url => "/:class/default_:style.png"

  has_mongoid_attached_file :badge_pic_grey, :styles => IMAGE_SIZES,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":class/:id/:style.:extension",
    :bucket => "badge_pics_grey_#{Rails.env}",  
    :default_url => "/:class/default_:style.png"
  
  has_mongoid_attached_file :badge_pic_small, :styles => IMAGE_SIZES,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":class/:id/:style.:extension",
    :bucket => "badge_pics_small_#{Rails.env}",  
    :default_url => "/:class/default_:style.png"
  

  validates_attachment_size :badge_pic, :less_than => 2.megabytes
  validates_attachment_content_type :badge_pic, :content_type => ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']  



  def badge_pic_url (size)
    if badge_pic.present?
      return badge_pic.url(size)
    # elsif provider == "facebook" and external_uid
    #   return "https://graph.facebook.com/#{external_uid}/picture"
    else
      return "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end
  end
 

  

end