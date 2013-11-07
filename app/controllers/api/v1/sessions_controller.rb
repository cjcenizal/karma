class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  

  respond_to :json


  

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    logger.info(params[:auth])


    user = User.find_for_facebook_mobile(params, current_user)
    user.save

    if user.persisted?
      sign_in user
      
      user.save

      render :status => 200,
           :json => { :success => true,
                      :info => "Logged in via FB.",
                      :data => { :user => user, # resource
                                 :auth_token => current_user.authentication_token } }
      #
    else
      render :status => 401,
             :json => { :success => false,
                        :info => "FB auth did not work.", #resource.errors,
                        :data => {} }
    end
  end

  def create
    logger.info("trying to create a session")
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user["avatar_url"] = current_user.avatar_url(:preview)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged in",
                      :data => { :user => current_user, :auth_token => current_user.authentication_token } }
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.reset_authentication_token
    sign_out resource
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end


# curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/v1/sessions -d "{\"user\":{\"email\":\"damien@gmail.com\",\"password\":\"password\"}}"
# curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X DELETE http://localhost:3000/api/v1/sessions/\?auth_token\=JRYodzXgrLsk157ioYHf