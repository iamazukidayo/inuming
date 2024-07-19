# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_deleted_user, only: [:create]

  def create
    @user = User.find_by(name: params[:user][:name])
    if @user && @user.valid_password?(params[:user][:password])
      sign_in(@user)
      flash[:login] = "ログインしました。"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "ユーザー名またはパスワードが間違っています。"
      render :new
    end
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    flash[:guest] = "ゲストユーザーとしてログインしました"
    redirect_to user_path(user)
  end

  protected

  def reject_deleted_user
    @user = User.find_by(name: params[:user][:name])
    if @user
      if @user.valid_password?(params[:user][:password]) && @user.is_deleted
        flash[:end] = "退会済みです。再度ご登録をしてご利用ください"
        redirect_to new_user_registration_path
      end
    end
  end



  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def after_sign_in_path_for(resource)
    root_path
    # 本当は投稿一覧へ行きたい
  end
end
