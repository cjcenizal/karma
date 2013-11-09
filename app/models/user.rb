class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Paperclip
  include ActiveModel::Validations
  

  

  before_save :ensure_authentication_token
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :omniauthable, :rememberable, :omniauth_providers => [:facebook]


  has_many :note_receiveds, :class_name => "Note", :inverse_of => :user_receiver
  has_many :note_givens, :class_name => "Note", :inverse_of => :user_giver 

  ## Database authenticatable
  field :email,                     :type => String, :default => ""
  field :encrypted_password,        :type => String, :default => ""
  field :displayname,               :type => String, :default => ""
  field :first_name,                :type => String, :default => ""
  field :last_name,                 :type => String, :default => ""
  field :phone_number,              :type => String, :default => ""

  field :give_count,                :type => Integer, :default => 0
  field :receive_count,             :type => Integer, :default => 0

  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :admin,   :type => Boolean, :default => true

  # field :fb_token,             :type => String
  # field :fb_secret,            :type => String
  # field :fb_uid,         :type => String
  # field :provider,             :type => String, :default => ""

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  field :authentication_token, :type => String

  field :dob,                :type => Date, :default => 13.years.ago
  field :gender,             :type => String, :default => ""
  field :optin,              :type => Boolean, :default => true
  field :aboutme,            :type => String, :default => ""
  field :homepage,           :type => String, :default => ""
  
  field :private,            :type => Boolean, :default => false

  # stats
  
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  # validates_presence_of :first_name, :last_name, :username
  # validates_uniqueness_of :username

# attr_accessible :avatar, :avatar_file_name

  IMAGE_SIZES = { :small => "150x150>" ,
      :preview => "200x200>",
      :large => "250x250>",
      :xlarge => "400x400>"}    
  
  has_mongoid_attached_file :avatar, :styles => IMAGE_SIZES,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :path => ":class/:id/:style.:extension",
    :bucket => "shout_avatars_#{Rails.env}",  
    :default_url => "/:class/default_:style.png"
  
  validates_attachment_size :avatar, :less_than => 4.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']  

  # def img_url(size)
  #   profile_photo_url
  # end

  def avatar_url (size)
    if avatar.present?
      return avatar.url(size)
    # elsif provider == "facebook" and external_uid
    #   return "https://graph.facebook.com/#{external_uid}/picture"
    else
      return "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase)}"
    end
  end


  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  def name 
    [first_name, last_name].join " " 
  end

 

  # def self.find_for_facebook_mobile(fb_info, signed_in_resource=nil)
  #   user = User.where(:fb_uid => fb_info[:fb_uid]).first
  #   unless user
  #     user = User.create(  first_name:fb_info[:first_name],
  #                          last_name:fb_info[:last_name],
  #                          provider:fb_info[:provider],
  #                          fb_uid:fb_info[:fb_uid],
  #                          email:fb_info[:email],
  #                          password:Devise.friendly_token[0,20],
  #                          fb_token: fb_info[:token],
  #                          username: fb_info[:username]
  #                          )
  #   end
  #   user
  # end

  # def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  #   user = User.where(:provider => auth.provider, :fb_uid => auth.uid).first
  #   unless user
  #     user = User.create(  first_name:auth.extra.raw_info.first_name,
  #                          last_name:auth.extra.raw_info.last_name,
  #                          provider:auth.provider,
  #                          fbuid:auth.uid,
  #                          email:auth.info.email,
  #                          username:auth.info.email,
  #                          password:Devise.friendly_token[0,20],
  #                          fb_token: auth.credentials.token,
  #                          fb_secret: auth.credentials.secret
  #                          )
  #   end
  #   user
  # end
end