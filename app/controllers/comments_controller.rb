class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  #before_action :check_user_followed, only: [:create]
  def show
    
  end
  def create

    @micropost = Micropost.find(params[:micropost_id])
    if current_user.following?(@micropost.user) || current_user?(@micropost.user)
    	@comment = @micropost.comments.build(comment_params)
    	@comment.user = current_user
   	  @comment.save
   	  respond_to do |format|
        format.html { redirect_to @micropost }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @micropost }
        format.js { render inline: "alert('Follow author to comment!');" }
      end
    end
  end

  def destroy

    @comment = Comment.find(params[:id])
    micropost = @comment.micropost
    @comment.destroy
    flash[:success] = 'Comment was successfully destroyed.'
    respond_to do |format|
      format.html { redirect_to micropost }
      format.json { head :no_content }
    end
  end

  private
  def comment_params
  	params.require(:comment).permit(:micropost_id,:content,:user_id)
  end
  def check_user_followed
  	user_post = Micropost.find(params[:micropost_id])
  	if current_user.following?(user_post.user)
  		return true
  	else 
  		flash[:danger] = "Follow author to comment!"
  	end
  end

end
