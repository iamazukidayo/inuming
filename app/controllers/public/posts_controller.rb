class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:ok] = "投稿されました"
      redirect_to posts_path
    else
      puts @post.errors.full_messages
      render :new
    end
  end

  def index
    if params[:sort] == 'likes'
      @posts = Post.joins(:likes).group(:id).order('COUNT(likes.id) DESC').page(params[:page]).per(12)
    else
      @posts = Post.order(created_at: :desc).page(params[:page]).per(12)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:post_update] = "変更が完了しました"
    redirect_to post_path(@post.id)
    else
    render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:post_destroy] = "削除されました"
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, images: [])
  end
end
