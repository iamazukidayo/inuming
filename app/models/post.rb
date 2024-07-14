class Post < ApplicationRecord
  has_many_attached :images
  # has_one_attached :images
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :images, presence: true


  def like_by?(user)
    user.present? && likes.exists?(user_id: user.id)
  end

  def self.liked_posts(user)
    includes(:likes)
    where(likes: {user_id: user.id})
    order(created_at: :desc)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @posts = Post.where("title LIKE ? OR body LIKE ?", word, word)
    elsif search == "forward_match"
      @posts = Post.where("title LIKE ? OR body LIKE ?", "#{word}%", "#{word}%")
    elsif search == "backward_match"
      @posts = Post.where("title LIKE ? OR body LIKE ?", "%#{word}", "%#{word}")
    elsif search == "partial_match"
      @posts = Post.where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")
    else
      @posts = Post.all
    end
  end



end



