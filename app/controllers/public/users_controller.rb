class Public::UsersController < ApplicationController
before_action :authenticate_user!, only: [:show, :edit, :update]
before_action :set_user, only: [:likes]

  def show
    @user = User.find(params[:id])
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id then
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      if @is_room
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
    @post = Post.new
    @posts = @user.posts
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
    @liked_posts = @user.liked_posts.page(params[:page]).per(9).order(created_at: :desc)
  end

  def out
    @user = User.find(current_user.id)
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to new_user_registration_path
  end




  private


  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
