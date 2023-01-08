class Public::PostCommentsController < ApplicationController
  def index
  end

  def edit
  end

  def create
    post=Post.find(params[:post_id])
    #comment = current_user.post_comments.new(post_comment_params)
    comment=PostComment.new(post_comment_params)
    comment.user_id = current_user.id

    comment.post_id = post.id
    comment.save
    redirect_to post_path(post.id)
  end

  def update
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
