# frozen_string_literal: true

class Bulletin < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, presence: true
  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    if image.byte_size > 5.megabytes
      errors.add(:image, 'must be less than 5 MB')
    elsif !image.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:image, 'must be a JPEG, PNG, or GIF')
    end
  end
end
