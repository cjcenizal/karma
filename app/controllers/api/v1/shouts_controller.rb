class Api::V1::ShoutsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  
  before_filter :authenticate_user!

  respond_to :json

  def index

    latitude = params[:lat].gsub(',','.').to_f
    longitude = params[:lon].gsub(',','.').to_f
    radius = params[:rad].gsub(',','.').to_f
    units = params[:units] #feet, meters, miles
    # shouts_local = Shout.geo_near([latitude, longitude])max_distance(radius)
     #order_by(:created_at => :desc). .distance_multiplier((6371 * Math::PI / 180))
    # miles to meters:     1609.34



    case units
    when "ft"
      shouts_local = Shout.geo_near([latitude, longitude]).max_distance(radius/68.7/5280)
    when "mi"
      shouts_local = Shout.geo_near([latitude, longitude]).max_distance(radius/68.7)
    when "m"
      shouts_local = Shout.geo_near([latitude, longitude]).max_distance(radius/68.7/1609.34)
    when "km"
      shouts_local = Shout.geo_near([latitude, longitude]).max_distance(radius/68.7/1.60934)
    else
      shouts_local = Shout.geo_near([latitude, longitude]).max_distance(radius/68.7/5280)
    end


    # shouts_local = Shout.geo_near([lat, long], :lat_long, {:mode => :sphere, :maxDistance => radius, :distanceMultiplier => (6371 * Math.PI / 180.0d)})
    
    # shouts_local.each do |shout|
    #   shout[:shout_pic_url] = shout.shout_pic_url("xlarge")
    # end
      
      
       if shouts_local

        
         render :status => 200,
           :json => { :success => true,
                      :info => "Local shouts retrieved.",
                      :data => { :count => shouts_local.count, :shouts => shouts_local} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Local shouts retrieved unsuccessfully.",
                      :data => {} }
      end
    
      # render :text => '{
      #   "success":false,
      #   "info":"user not signed in",
      #   "data":{}}'
    end
                  
    #     render :text => '{
    #   "success":true,
    #   "info":"ok",
    #   "data":{
    #           "tasks":[
    #                     {"title":"Complete the app"},
    #                     {"title":"Complete the tutorial"}
    #                   ]
    #          }
    # }'

    def hashtag_search
      shouts = Shout.full_text_search(params[:hashtag]).order_by(:created_at => :desc)

      if shouts
        
         render :status => 200,
           :json => { :success => true,
                      :info => "Hash tagged shouts retrieved.",
                      :data => { :shouts => shouts} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Hash tag search failed.",
                      :data => {} }
      end

    end



    def user_shouts
      # user = User.find(params[:user_id])
      shouts = Shout.where(user_id: params[:user_id]).order_by(:created_at => :desc)
      logger.info(shouts)

      # shouts.each do |shout|
      #   shout[:shout_pic_url] = shout.shout_pic_url("xlarge")
      #   # shout.save
      # end

      if shouts
        
         render :status => 200,
           :json => { :success => true,
                      :info => "User's shouts retrieved.",
                      :data => { :count => shouts.count, :shouts => shouts} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "User's shouts not retrieved.",
                      :data => {} }
      end

    end

    def show
      shout_id = params[:shout_id] # retrieve movie ID from URI route
      shout = Shout.find(shout_id) # look up movie by unique ID
      shout[:shout_pic_url] = shout.shout_pic.url(:original)
      shout[:amp_activity] = shout.amp_activity
      
      if shout
         render :status => 200,
           :json => { :success => true,
                      :info => "Shout retrieved.",
                      :data => { :shout => shout} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Shout not retrieved.",
                      :data => {} }
      end

    end

    def recent
      
      shouts = Shout.order_by(:created_at => :desc).limit(30)
      
      
      if shouts
         render :status => 200,
           :json => { :success => true,
                      :info => "Recent shouts retrieved.",
                      :data => { :shouts => shouts} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Recent shouts not retrieved.",
                      :data => {} }
      end

    end
    
    

    def upload
      data = {}
      data["shout_pic"] = params[:files]
      shout = Shout.find(params[:shout_id])
      user = User.find(current_user.id)
      if user._id != shout.user_id
        render :json => {:status => 501, :error => "user does not own that shout"}
      else

        shout.update_attributes(data)
        if shout.save(:validate => false)
          render :status => 200,
                 :json => { :success => true,
                            :info => "Shout pic uploaded successfully.",
                            :shout_url => shout.shout_pic.url(:original)}
        else
          render :status => 401 ,
                 :json => { :success => false,
                            :info => "Shout pic uploaded unsuccessfully.",
                            :data => {} }
        end
      end    


    end

    def create
        shout = Shout.new(params[:shout])

        shout["user_id"] = current_user._id
        current_user.shout_count += 1

        if shout.save

          badge = Badge.where(:name => shout.city).first
          
          if badge
            
            current_user.add_to_set(:badge_ids, badge._id)
            badge.add_to_set(:user_ids, current_user._id)
            badge.save
            
          end
          current_user.save
          render :status => 200,
           :json => { :success => true,
                      :info => "Shout saved.",
                      :data => { :shout => shout} }
        else

        render :status => 401,
               :json => { :success => false,
                          :info => "Error saving shout.",
                          :data => {} }
        end
      end

    def failure
      render :status => 401,
           :json => { :success => false,
                      :info => "Request Failed",
                      :data => {} }
  end

  def amplify
      score = params[:score].to_i
      shout_id = params[:shout_id]
      shout = Shout.find(shout_id) # look up movie by unique ID
      
      amp = Amplification.where(shout_id: shout_id, user_id: current_user._id).first

      if amp
        amp.score = score
        #amp.update_attributes(:score => score)
        
      else
        amp = Amplification.new(:score => score, :shout_id => shout_id, :user_id => current_user._id)
        
      end

      if amp.save
        shout[:amplification] = shout.amplification_count
        amp.save
        shout.save
        render :status => 200,
             :json => { :success => true,
                        :info => "Amplification successful.",
                        :data => { :amplification => amp,
                                    :shout => shout} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Amplification failed.",
                      :data => {} }
      end

    end
    def destroy
      shout = Shout.find(params[:shout_id])

      current_user.shout_count -= 1
      
      

      if shout.destroy
        current_user.save  
        render :status => 200,
             :json => { :success => true,
                        :info => "Shout deleted.",
                        :data => {} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Shout deletion failed.",
                      :data => {} }
      end
    end
  
end