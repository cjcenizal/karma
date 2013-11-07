class Shout
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip
  include Mongoid::Search
  include Geocoder::Model::Mongoid
  
  reverse_geocoded_by :geoloc_rev
  reverse_geocoded_by :geoloc_rev do |obj,results|
    if geo = results.first
      obj.address     = geo.address
      obj.city        = geo.city
      obj.zipcode     = geo.postal_code
      
      obj.state       = geo.state
      # obj.state_code  = geo.state_code

      obj.country     = geo.country_code
    end
  end

  before_validation :reverse_geoloc, :factual_check
  after_validation :reverse_geocode  # auto-fetch address

  before_create :extract_hashtags
  before_save :small_pic_url_get

  belongs_to :user
  has_many :amplifications
  has_many :tags
  has_many :comments

  search_in :tags => :name

  acts_as_gmappable :position => :geoloc, :process_geocoding => false
    
  field :content,         :type => String, :default => ""
  field :shout_type,      :type => String, :default => ""
  field :radius,          :type => Float, :default => 1.0
  field :upvotes,         :type => Integer, :default => 0
  field :downvotes,       :type => Integer, :default => 0
  field :amplification,   :type => Integer, :default => 0
  field :expiration,      :type => Integer, :default => 1209600 # 2 weeks in seconds
  
  field :geoloc,          :type => Array, :default => []
  field :geoloc_rev,      :type => Array, :default => []
  field :address,         :type => String, :default => ""
  field :city,            :type => String, :default => ""
  field :state,            :type => String, :default => ""
  field :sate_code,       :type => String, :default => ""
  field :zipcode,          :type => String, :default => ""
  field :country,         :type => String, :default => ""

  field :flag,            :type => String, :default => ""
  field :gmaps,           :type => Boolean
  field :small_pic_url,:type => String
  # field :expiration_time, :type => Time, :default => Time.now +1.day

  def gmaps4rails_address
#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
  # "#{self.street}, #{self.city}, #{self.country}" 
end



  def reverse_geoloc
    self.geoloc_rev = self.geoloc.reverse
  end

  def factual_check
    factual = Factual.new("xe6ym5IVW4QUWpKyEOhhWnYSYTUv6TAmI4GAKa5h", "xxcdSNzLIrrOVwYYrVO6pNobGCUSeEjj4f6KaVgH")
    # query = factual.geopulse(self.geoloc[0],self.geoloc[1]).select("race_and_ethnicity")

    query = factual.table("places").limit(1).geo("$point" => self.geoloc)
  

    
    logger.info(query.to_a)
  end
index({geoloc: "2d"})

IMAGE_SIZES = { :small => "150x150>" ,
      :preview => "200x200>",
      :large => "250x250>",
      :xlarge => "400x400>"}    
  
  has_mongoid_attached_file :shout_pic, :styles => IMAGE_SIZES,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":class/:id/:style.:extension",
    :bucket => "shout_pics_#{Rails.env}",  
    :default_url => "/:class/default_:style.png"
  
  validates_attachment_size :shout_pic, :less_than => 10.megabytes
  validates_attachment_content_type :shout_pic, :content_type => ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']  



  def shout_pic_url (size)
    if shout_pic.present?
      return shout_pic.url(size)
    # elsif provider == "facebook" and external_uid
    #   return "https://graph.facebook.com/#{external_uid}/picture"
    else
      return nil
    end
  end

  def amplification_count
    return self.amplifications.sum(:score)
  end

  def amp_activity
    self.amplifications.desc(:created_at)

  end



  def extract_hashtags
    
    hashtag_regex = /\#\w\w+/
    hashtags = self.content.scan(hashtag_regex)
    hashtags.each do |hashtag|
      self.tags << Tag.new(:name => hashtag)
    end
  end


    
  
def small_pic_url_get
    
    self.small_pic_url = shout_pic.url("small")
  end
 


  

end