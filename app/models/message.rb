class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :message, presence: true, lenrth: { maximum: 140 }
end
