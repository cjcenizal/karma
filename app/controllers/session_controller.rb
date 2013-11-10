class SessionController < Devise::SessionsController

  def destroy
    render :json => {
      :url => users_url
    }
  end

end
