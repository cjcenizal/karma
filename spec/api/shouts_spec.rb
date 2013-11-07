require 'spec_helper'

describe '/api/v1/shouts', :api do
   # before { get api_shouts_path }

   before(:each) do
    30.times { FactoryGirl.create(:shout) }
    
  end

  # it { last_response.status.should eq 200 }

  it 'should return local shouts' do
  	user = FactoryGirl.create(:user)
  	get "/api/v1/shouts", 	:format => :json, 
  							:authentication_token => user.authentication_token,
  							:latitude => 45.5,
  							:longitude => -73.5,
  							:radius => 1000
  	response.status.should eq("success")



    
  end
end

def api_shouts_path
	"api/v1/shouts"

end





