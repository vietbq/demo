class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
	
  def home
    @posts = Micropost.paginate(page: params[:page])
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to home_path
    else
    	@feed_items = []
      render 'static_pages/home'
    end
  end

  def show
      @micropost = Micropost.find(params[:id])
      @comment  = @micropost.comments.build
      @comments = @micropost.comments.includes(:user)
      @microposts = Micropost.where.not(id: params[:id]).limit(10)
  end

  def edit
      @micropost = Micropost.find(params[:id])
  end

  def update
      @micropost = Micropost.find(params[:id])
      if @micropost.update_attributes(micropost_params)
        flash[:success] = "Micropost updated"
        redirect_to @micropost
      else
        render 'edit'
      end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
    def micropost_params
      params.require(:micropost).permit(:title,:content, :picture)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
