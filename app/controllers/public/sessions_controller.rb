# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def create
    @user = User.find_by(name: params[:user][:name])
    if @user && @user.valid_password?(params[:user][:password])
      sign_in(@user)
      flash[:login] = "ログインしました。"
      redirect_to posts_path
    else
      flash.now[:alert] = "ユーザー名またはパスワードが間違っています。"
      render :new
    end
  end

  protected

  def reject_end_user
    @end_user = EndUser.find_by(name: params[:end_user][:name])
    if @end_user
      if @end_user.valid_password?(params[:end_user][:password]) && (@end_user.is_deleted == true)
        flash[:end] = "退会済みです。再度ご登録をしてご利用ください"
        redirect_to new_user_registration_path
      # else
      # 該当するユーザが見つからない場合やパスワードが違う場合の処理
        # flash[:login_notice] = "メールアドレスまたはパスワードが正しくありません"
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
