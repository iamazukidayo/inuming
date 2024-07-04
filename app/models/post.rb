class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user



  def get_image(width, height)
      unless image.attached?
        "no_image.png"
      else
        image.variant(resize_to_fill: [width, height]).processed
      end
  end
end


