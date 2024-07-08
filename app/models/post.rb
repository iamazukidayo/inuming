class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :image, presence: true


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


