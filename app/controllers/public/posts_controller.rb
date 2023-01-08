class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest, only: %i[update]


  def new
    @post=Post.new
    @tags=Tag.mapped
  end

  def create
    #@posts=Post.all
    @post=Post.new(post_params)
    #split(nil)だと会員が全角ｽﾍﾟｰｽでﾀｸﾞを分割したとき、意図しないタグが生成され
    tag_list=params[:post][:tag_name].split(/[[:blank:]]/)
    @post.user_id=current_user.id
    if @post.save
      @post.save_posts(tag_list)
      redirect_to posts_path
    else
      flash.now[:alert]="投稿に失敗しました"
      @tags=Tag.mapped
      render :new
    end
  end

  def search
     if params[:keyword].present?
      begin
        posts=Post.publish.search(params[:keyword]).page(params[:page])
      rescue StandardError => e
        redirect_to posts_path, alert: e.message
      end
      #paramsの中身が[:search]になっていたのをkeywordに統一
    elsif params[:tag_id].present?
      @tag=Tag.find(params[:tag_id])
      posts=@tag.posts.publish.order(created_at: :desc)
    else
      posts = Post.all.publish.order(created_at: :desc)
    end
    # byebug
    @tags=Tag.mapped
    @posts=posts.page(params[:page]).per(30)
    @genres=Genre.all
    #@posts = Post.search(params[:keyword])
    @keyword = params[:keyword]
    render "index"
  end

  def index
    if params[:keyword].present?
      begin
        posts=Post.publish.search(params[:keywrod])
      rescue StandardError => e
        redirect_to posts_path, alert: e.message
      end
      #posts.rbに定義したﾒｿｯﾄﾞはkeywordで：がついてないけどOK
    elsif params[:tag_id].present?
      @tag=Tag.find(params[:tag_id])
      posts=@tag.posts.publish.order(created_at: :desc)
    else
      posts = Post.all.publish.order(created_at: :desc)
    end
    @tags=Tag.mapped
    @genres=Genre.all
    if params[:genre_id]
      @posts=posts.where(genre_id: params[:genre_id]).page(params[:page]).per(30)
    else
      @posts=posts.page(params[:page]).per(30)
    end
  end

  def show
    @post=Post.find(params[:id])
    @post_comment=PostComment.new
    @tags=Tag.mapped
  end

  def edit
    @tags=Tag.mapped
    @post=Post.find(params[:id])
    @post_comment=PostComment.new

  end

  def update
    # @tag=Tag.find(params[:tag_id])
    @post=Post.find(params[:id])
    @post_comment=PostComment.new
    @tags=Tag.mapped
    tag_list=params[:post][:tag_name].split(/[[:blank:]]/)
    @post.save_posts(tag_list)
    @post.update(post_params)
    render :show
  end

  private
  def post_params
    params.require(:post).permit(:post_status, :title, :body, :user_id, :genre_id, :image, post_images:[])
  end

  def check_guest
    if current_user.email == 'guest@example.com'

     flash[:notice] = 'ゲストユーザーでの変更・削除はできません。'
     redirect_to root_path
    end
  end
end
