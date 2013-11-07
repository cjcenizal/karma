class Api::V1::FriendshipsController < ApplicationController
   skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  
  before_filter :authenticate_user!

  respond_to :json

  def create
  	friendship = Friendship.new(params[:friendship])

    friendship.follower = current_user
    friendship.followee = User.find(params[:followee_id])
    
    if friendship.save
      current_user.save
      render :status => 200,
       :json => { :success => true,
                  :info => "Friendship saved.",
                  :data => { :friendship => friendship} }
    else

    render :status => 401,
           :json => { :success => false,
                      :info => "Error saving friendship.",
                      :data => {} }
    end

  end

  def retrieve
  	friendships = Friendship.where(follower_id: params[:follower_id])

  	 if friendships
      
      render :status => 200,
       :json => { :success => true,
                  :info => "Friendships retrieved.",
                  :data => { :friendships => friendships} }
    else

    render :status => 401,
           :json => { :success => false,
                      :info => "Error retrieving friendships.",
                      :data => {} }
    end

end




end