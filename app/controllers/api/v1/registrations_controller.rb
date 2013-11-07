class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    # build_resource

    logger.info(params[:email])
    logger.info(params[:password])
    logger.info(params[:password_confirmation])
    logger.info(params[:username])
    user = User.new(:email => params[:email], 
                    :password => params[:password], 
                    :password_confirmation => params[:password_confirmation], 
                    :username => params[:username],
                    :first_name => params[:first_name],
                    :last_name => params[:last_name])
    
    # resource
    # resource.skip_confirmation!
    
    

    if user.save #resource.save #
      logger.info("blah")
      sign_in user

      
      logger.info("blahblah")
     
      render :status => 200,
             :json => { :success => true,
                        :info => "Registered successfully.",
                        :data => { :user => user, # resource
                                 :auth_token => current_user.authentication_token } }
    else
      
      render :status => 401,
             :json => { :success => false,
                        :info => "error", #resource.errors,
                        :data => {} }
    end
  end

  def facebook
    
    
    # auth = {:fb_token => params[:fb_token], :provider => 

    user = User.find_for_facebook_mobile(params, current_user)
    # user.update_attributes(:username => params[:username]) 
    user.save
    if user.persisted?
      sign_in user
      
      

      render :status => 200,
           :json => { :success => true,
                      :info => "Registered via FB.",
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
end

# curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/v1/registrations -d "{\"user\":{\"email\":\"user1@example.com\",\"password\":\"secret\",\"password_confirmation\":\"secret\"}}"