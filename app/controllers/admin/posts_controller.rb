class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  #def new
   #@post=Post.new
  #end

  #def create
    #@post=Post.new(post_params)
    #@post.user_id=current_user.id
    #@post.save
    #redirect_to posts_path
  #end

  def index
    @posts = Post.all
  end

  def show
    @post=Post.find(params[:id])
    @post_comment=PostComment.find(params[:id])
  end

  def destroy
    @posts=Post.all
    @post=Post.find(params[:id])
    @post.destroy
    redirect_to admin_root_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :user_id, :genre_id, :image, post_images:[])
  end
end