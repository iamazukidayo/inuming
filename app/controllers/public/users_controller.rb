class Public::UsersController < ApplicationController
before_action :authenticate_user!, only: [:show, :edit, :update]
before_action :set_user, only: [:likes]

 def show
   @user = User.find(params[:id])
   @posts = @user.posts.order(created_at: :desc)
 end


  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
      redirect_to user_path(@user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:user_update] = "変更が登録されました"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def liked_posts
    @user = User.find(params[:id])
    @liked_posts = @user.liked_posts
  end

  def out
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end




  private


  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
