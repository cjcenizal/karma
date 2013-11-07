require "spec_helper"

describe "API errors", :api do

  it "making a request with no token" do
    get "/api/v1/shouts", :authentication_token => "", :format => :json
    error = { :error => "You need to sign in or sign up before continuing." }

    last_response.body.should eql(error.to_json)
  end

  

end