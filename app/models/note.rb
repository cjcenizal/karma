class Note
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

  before_validation :reverse_geoloc #, :factual_check
  after_validation :reverse_geocode  # auto-fetch address

  before_save :extract_hashtags
  

  belongs_to  :notecollection
  belongs_to  :user_giver, :class_name => "User", :inverse_of => :note_givens#, :foreign_key => "giver_id" 
  belongs_to  :user_receiver, :class_name => "User", :inverse_of => :note_receiveds#, :foreign_key => "receiver_id"
  has_and_belongs_to_many   :virtualusers

  has_many    :tags
  search_in   :tags => :name

  acts_as_gmappable :position => :geoloc, :process_geocoding => false
    

  # properties

  field :content,                 :type => String, :default => ""
  field :note_index,              :type => Integer, :default => 0

  field :is_private_name_giver,      :type => Boolean, :default => false
  field :is_private_content_giver,   :type => Boolean, :default => false
  field :is_private_picture_giver,   :type => Boolean, :default => false

  field :is_private_name_receiver,    :type => Boolean, :default => false
  field :is_private_content_receiver,   :type => Boolean, :default => false
  field :is_private_picture_receiver,   :type => Boolean, :default => false

  field :expiration,                :type => Integer, :default => 1209600 # 2 weeks in seconds
  
  field :geoloc,                    :type => Array, :default => []
  field :geoloc_rev,                :type => Array, :default => []
  field :address,                 :type => String, :default => ""
  field :city,                    :type => String, :default => ""
  field :state,                   :type => String, :default => ""
  field :sate_code,               :type => String, :default => ""
  field :zipcode,                 :type => String, :default => ""
  field :country,                 :type => String, :default => ""

  field :flag,                    :type => String, :default => ""
  field :gmaps,                   :type => Boolean

  attr_accessor :email, :phone_number, :displayname, :user_code, :find_type
  
  # field :expiration_time, :type => Time, :default => Time.now +1.day

  def next_note
  end

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
    
    has_mongoid_attached_file :picture, :styles => IMAGE_SIZES,
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3.yml",
      :path => ":class/:id/:style.:extension",
      :bucket => "picture_#{Rails.env}"
      
    
    validates_attachment_size :picture, :less_than => 10.megabytes
    validates_attachment_content_type :picture, :content_type => ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']  


    def check_receiver
      read_attribute(:user_receiver).presence || ""
    end

    def extract_hashtags
      
      hashtag_regex = /\#\w\w+/
      hashtags = self.content.scan(hashtag_regex)
      hashtags.each do |hashtag|
        self.tags << Tag.new(:name => hashtag)
      end
    end


end