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
      respond_to do |format|
      format.html # new.html.erb
      
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
