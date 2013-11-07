# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Shoutapp::Application.initialize!

Twitter.configure do |config|
  config.consumer_key = "qDdC6EEBTqtcB1bjfKdRw"
  config.consumer_secret = "LvosOMDN4dq1YbBSfOM6L27VTIsmg1ZwXOPg"
  config.oauth_token = "17958535-RERt1grK8JLfDSR96azWZk8vEXr9kWjOUybVm1i40"
  config.oauth_token_secret = "IEPxwcTK8U58Vn9oisCMNWb3d5uVKlYsJmuD9RI"
end
