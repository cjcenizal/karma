require 'random'
require 'sentence'
class HomeController < ApplicationController
  def index

    prng = Random.new()
    @test_notes = []
    for i in 0..40
      thanks_in = "Thanks!"
      thanks_out = "No, thank YOU!"
      count = prng.rand
      @test_notes.push(Struct.new(:thanks_in,:thanks_out,:count).new(thanks_in,thanks_out,count))
    end

  	# @sentences = Array.new
  	@shouts2= Shout.all
  @shouts = Shout.all
  @shouts_json = @shouts.to_gmaps4rails do |shout, marker|
  marker.infowindow render_to_string(:partial => "/shouts/infowindow", :locals => { :shout => shout})
    marker.title "example"
    marker.json({ :content => shout.geoloc})
    # marker.picture({:picture => "http://mapicons.nicolasmollet.com/     wp-content/uploads/mapicons/shape-default/color-3875d7/shapeco     lor-color/shadow-1/border-dark/symbolstyle-contrast/symbolshad     owstyle-dark/gradient-iphone/information.png",
    #                 :width => 32,
    #                 :height => 32})
  end

  @vendors = @shouts2.geo_near([41.99999,-88.0507625]).max_distance(20)

  @tweets = Twitter.search("", :geocode => "37.781157,-122.3987,20mi").results
  logger.info(@tweets)

  # .map do |status|
  # "#{status.from_user}: #{status.text}"
  # end
  
  	respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shouts2 }
    end

  end


  def privacy
    respond_to do |format|
      format.html # new.html.erb
      
    end

  end
end
