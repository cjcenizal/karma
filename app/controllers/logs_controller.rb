class LogsController < ApplicationController
  


  def development

    @last = %x(tail -n 500 log/development.log)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @last }
    end

  end
  def production

    @last = %x(tail -n 500 log/production.log)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @last }
    end

  end

end
