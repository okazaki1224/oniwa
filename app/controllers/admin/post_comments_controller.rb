class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts=Post.all
  end

  def edit
  end

  def update
    @post=Post.find(params[:post_id])
    #ここはpost_commentｺﾝﾄﾛｰﾗなのでparams[:id]だとコメントのIDを取得してしまう。当然15行目にも影響が出る（出ていた
    @post_comment=PostComment.find(params[:id])
    @post_comment.update(post_comment_params)
    redirect_to admin_post_path(@post.id)
  end

  def destroy
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment, :is_deleted)
  end
end