class NotesController < ApplicationController
  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.json
  def new
    @note = Note.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.json
  def create
    @notecollection = Notecollection.new()
    @note = Note.new(params[:note].merge({:notecollection_id => @notecollection._id}))

    @note.user_giver = current_user

    case params[:note][:find_type]
    when "email"
      
      user = User.where(email: params[:note][:email]).first
      unless user
        user = Virtualuser.where(email: params[:note][:email]).first_or_initialize
        @note.add_to_set(:virtualuser_ids, user._id)
        user.receive_count += 1
        user.save
      end
      
      @note.user_receiver = user
      user.receive_count += 1
      user.save

    when "phone_number"
      
      user = User.where(phone_number: params[:phone_number]).first
      
      unless user
        user = Virtualuser.where(phone_number: params[:phone_number]).first_or_initialize
        @note.add_to_set(:virtualuser_ids, user._id)
        user.receive_count += 1
        user.save
        
      end
      
      @note.user_receiver = user
      user.receive_count += 1
      user.save
    else
    end

    respond_to do |format|
      if @note.save
        @notecollection.save
        current_user.give_count += 1
        current_user.save

        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.json
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    respond_to do |format|
      format.html { redirect_to notes_url }
      format.json { head :no_content }
    end
  end



  def pass
    @notecollection = params[:collection_id]
    
    @note = Note.new(params[:note].merge({:notecollection_id => @notecollection}))

    @note.user_giver = current_user

    case params[:note][:find_type]
    when "email"
      
      user = User.where(email: params[:note][:email]).first
      unless user
        user = Virtualuser.where(email: params[:note][:email]).first_or_initialize
        @note.add_to_set(:virtualuser_ids, user._id)
        user.receive_count += 1
        user.save
      end
      @note.user_receiver = user
      user.receive_count += 1
      user.save

    when "phone_number"
      
      user = User.where(phone_number: params[:phone_number]).first
      
      unless user
        user = Virtualuser.where(phone_number: params[:phone_number]).first_or_initialize
        @note.add_to_set(:virtualuser_ids, user._id)
        user.receive_count += 1
        user.save
        
      end
      @note.user_receiver = user
      user.receive_count += 1
      user.save
    else
    end

    respond_to do |format|
      if @note.save
        
        current_user.give_count += 1
        current_user.save
        
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render json: @note, status: :created, location: @note }
      else
        format.html { render action: "new" }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def pass_new
    @notecollection = params[:collection_id]
    @note = Note.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @note }
    end
  end


end
