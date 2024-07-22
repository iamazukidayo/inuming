class Admin::CommentsController < ApplicationController

  def index
    @comments = Comment.includes(:post, :user).order(created_at: :desc).page(params[:page]).per(10)
    @users = User.all
  end


  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path
  end
end
