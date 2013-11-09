class NotecollectionsController < ApplicationController
  # GET /notecollections
  # GET /notecollections.json
  def index
    @notecollections = Notecollection.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notecollections }
    end
  end

  # GET /notecollections/1
  # GET /notecollections/1.json
  def show
    @notecollection = Notecollection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notecollection }
    end
  end

  # GET /notecollections/new
  # GET /notecollections/new.json
  def new
    @notecollection = Notecollection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notecollection }
    end
  end

  # GET /notecollections/1/edit
  def edit
    @notecollection = Notecollection.find(params[:id])
  end

  # POST /notecollections
  # POST /notecollections.json
  def create
    @notecollection = Notecollection.new(params[:notecollection])

    respond_to do |format|
      if @notecollection.save
        format.html { redirect_to @notecollection, notice: 'Notecollection was successfully created.' }
        format.json { render json: @notecollection, status: :created, location: @notecollection }
      else
        format.html { render action: "new" }
        format.json { render json: @notecollection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notecollections/1
  # PUT /notecollections/1.json
  def update
    @notecollection = Notecollection.find(params[:id])

    respond_to do |format|
      if @notecollection.update_attributes(params[:notecollection])
        format.html { redirect_to @notecollection, notice: 'Notecollection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @notecollection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notecollections/1
  # DELETE /notecollections/1.json
  def destroy
    @notecollection = Notecollection.find(params[:id])
    @notecollection.destroy

    respond_to do |format|
      format.html { redirect_to notecollections_url }
      format.json { head :no_content }
    end
  end
end
