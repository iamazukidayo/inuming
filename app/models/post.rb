class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy



  def like_by?(user)
    likes.exists?(user_id: user.id)
  end



  def get_image(width, height)
      unless image.attached?
        "no_image.png"
      else
        image.variant(resize_to_fill: [width, height]).processed
      end
  end

  def self.liked_posts(user)
    includes(:likes)
    where(likes: {user_id: user.id})
    order(created_at: :desc)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end


end


