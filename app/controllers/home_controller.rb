require 'random'
require 'sentence'
class HomeController < ApplicationController
  def index

    @notes = []
    if current_user
      @notes = current_user.note_receiveds.desc(:time_created)
    end
    @user = current_user
    @home_json = {
      :user => current_user
    }.to_json
    respond_to do |format|
      format.html # new.html.erb
    end

  end

  def map
    @notes = Note.all
    @notes = @notes.to_gmaps4rails do |note, marker|
       marker.infowindow render_to_string(:partial => "/notes/infowindow", :locals => { :note => note})
        marker.title "example"
        marker.json({ :content => note.geoloc})
        # marker.picture({:picture => "http://mapicons.nicolasmollet.com/     wp-content/uploads/mapicons/shape-default/color-3875d7/shapeco     lor-color/shadow-1/border-dark/symbolstyle-contrast/symbolshad     owstyle-dark/gradient-iphone/information.png",
        #                 :width => 32,
        #                 :height => 32})
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notes }
    end
 end


  
  
  def tag_search
    @notes = Note.full_text_search(params[:hashtag]).order_by(:created_at => :desc)


  

  # .map do |status|
  # "#{status.from_user}: #{status.text}"
  # end
  
  	respond_to do |format|
      format.html # new.html.erb
      
    end

  end


  def privacy
    respond_to do |format|
      format.html # new.html.erb
      
    end

  end
end
