class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[myfavorites show edit unsubscribe]
  before_action :check_guest, only: %i[update withdraw]

  def myfavorites
    @tag_lists=Tag.all
    @tag_lists=Tag.find(Tagmap.group(:tag_id).order('count(post_id) desc').limit(30).pluck(:tag_id))
    #@user=User.find(params[:id])
    myfavorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @myfavorite_posts = Post.find(myfavorites)
  end

  def index
    @users=User.all
    @tag_lists=Tag.find(Tagmap.group(:tag_id).order('count(post_id) desc').limit(30).pluck(:tag_id))
  end

  def show
    @tag_lists=Tag.find(Tagmap.group(:tag_id).order('count(post_id) desc').limit(30).pluck(:tag_id))
    @posts=@user.posts

  end

  def edit
    @tags=Tag.mapped
    #@user=User.find(params[:id])
  end

  def update
    @tag_lists=Tag.mapped
    @user=current_user
    if @user.update(user_params)
      redirect_to user_path(@user.id),notice: "プロフィールを更新しました！"
    else
      render :edit
    end
  end

  def unsubscribe
    #@user=User.find(params[:id])
  end

  def withdraw
    @user = current_user
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private
  def user_params
      params.require(:user).permit(:email, :encrypted_password, :last_name, :first_name,
      :nickname, :introduction, :profile_image, :is_deleted)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_guest
    if current_user.email == 'guest@example.com'

     flash[:notice] = 'ゲストユーザーでの変更・退会はできません。'
     redirect_to root_path
    end
  end

end