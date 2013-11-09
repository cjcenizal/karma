class Virtualuser
	include Mongoid::Document
  	include Mongoid::Timestamps


  	has_and_belongs_to_many :notes

  	after_save :new_user_sms

  	field :email,				:type => String, :default => ""
  	field :phone_number,		:type => String, :default => ""


 	field :receive_count,         :type => Integer, :default => 0



	def new_user_sms

		if self.phone_number != ""
		account_sid = 'AC40699c2980c4b16d5e8839ebc8482e13'
		auth_token = 'b104c6a5791ecd8d526f35329077fda1'

		@client = Twilio::REST::Client.new account_sid, auth_token

		@client.account.messages.create(
		  :from => '+12242552762',
		  :to => '+17756237664',
		  :body => 'Kohl"s Roulette!',
		  :media_url => 'http://example.com/smileyface.jpg',
		)
		end
	end

end
  