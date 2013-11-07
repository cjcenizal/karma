class Api::V1::CommentsController < ShoutsController
   skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  
  before_filter :authenticate_user!

  respond_to :json


  def create
    comment = Comment.new(params[:comment])

    comment["user_id"] = current_user._id
    comment["shout_id"] = params[:shout_id]
    
    current_user.comment_count +=1

    logger.info(current_user.to_a)

    if comment.save
      current_user.save
      render :status => 200,
       :json => { :success => true,
                  :info => "Comment saved.",
                  :data => { :comment => comment} }
    else

    render :status => 401,
           :json => { :success => false,
                      :info => "Error saving comment.",
                      :data => {} }
    end
  end

  def destroy
      comment = Comment.find(params[:comment_id])

      current_user.comment_count -= 1
      
      

      if comment.destroy
        current_user.save  
        render :status => 200,
             :json => { :success => true,
                        :info => "Comment deleted.",
                        :data => {} }
      else
        render :status => 401,
           :json => { :success => false,
                      :info => "Comment deletion failed.",
                      :data => {} }
      end
    end













end