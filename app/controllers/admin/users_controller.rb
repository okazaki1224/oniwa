class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @users=User.all
  end

  def show
    @user=User.find(params[:id])
    @posts=@user.posts
  end
  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id),notice: "プロフィールを更新しました！"
    else
      render :edit
    end
  end

  private
  def user_params
      params.require(:user) .permit(:email, :encrypted_password, :last_name, :first_name,
                                      :nickname, :introduction, :profile_image, :is_deleted)
  end


end