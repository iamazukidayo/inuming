class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  has_many :posts, dependent: :destroy




 def get_profile_image(width, height)
      unless profile_image.attached?
        "no_image.jpg"
      else
        profile_image.variant(resize_to_limit: [width, height]).processed
      end
 end
end
