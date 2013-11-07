class Api::V1::UsersController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  

  respond_to :json



  def show
      user_id = params[:user_id]
      user = User.find(user_id)
      profile ={}
      profile[:username] = user.username
      profile[:gender] = user.gender
      profile[:aboutme] = user.aboutme
      profile[:homepage] = user.homepage
      profile[:avatar] = user.avatar.url(:preview)
      profile[:avatar_small] = user.avatar.url(:small)
      profile[:amp_activity] = user.amp_activity
      profile[:badges] = user.badges
      profile[:following] = user.
      
      render :status => 200,
             :json => {:success => true,
                        :info => "profile retrieved",
                        :profile => profile}

    end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "No user with that id.",
                      :data => {} }
  end
end


# curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST http://localhost:3000/api/v1/sessions -d "{\"user\":{\"email\":\"damien@gmail.com\",\"password\":\"password\"}}"
# curl -v -H 'Content-Type: application/json' -H 'Accept: application/json' -X DELETE http://localhost:3000/api/v1/sessions/\?auth_token\=JRYodzXgrLsk157ioYHf