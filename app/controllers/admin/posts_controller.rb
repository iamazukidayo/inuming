class Admin::PostsController < ApplicationController
before_action :authenticate_admin!
  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(10)
    @users = User.all
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end
end
