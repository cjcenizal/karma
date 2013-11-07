class Api::V1::ProfileController < ApplicationController  
  skip_before_filter :verify_authenticity_token

  before_filter :authenticate_user!

  def upload
    data = {}
    data["avatar"] = params[:files]
    user = User.find(current_user.id)
    user.update_attributes(data)
    if user.save(:validate => false)
      render :status => 200, 
            :json =>  {:success => true,
                       :info => "Avatar uploaded",
                       :avatar_url => user.avatar.url(:preview) }
    else
      render :status => 401,
             :json => {:success => true,
                       :info => "Avatar upload unsuccessful.",
                       :data => {} }
    end
  end

  def update
   
      if current_user.update_attributes(params[:user])
        
         render :status => 200,
                :json => { :success => true,
                      :info => "Profile updated.",
                      :data => { :user => current_user} }
      else
        render :status => 401,
               :json => { :success => false,
                          :info => "Profile not updated.",
                          :data => {} }
      end
     
  end

   def show
    
      user_id = params[:user_id]
      user = User.find(user_id)
      profile ={}
      profile[:user_id] = user._id
      profile[:username] = user.username
      profile[:gender] = user.gender
      profile[:aboutme] = user.aboutme
      profile[:homepage] = user.homepage
      profile[:avatar] = user.avatar.url(:preview)
      profile[:avatar_small] = user.avatar.url(:small)
      profile[:amp_activity] = user.amp_activity
      profile[:shout_count] = user.shout_count
      profile[:following?] = user.friendships.where(followee_id: current_user._id)
      
      render :status => 200,
             :json => {:success => true,
                        :info => "profile retrieved.",
                        :profile => profile}

    end


end