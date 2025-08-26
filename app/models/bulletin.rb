# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :category

  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, presence: true
  validate :acceptable_image

  scope :published, -> { where(state: 'published') }
  scope :under_moderation, -> { where(state: 'under_moderation') }

  aasm column: :state do
    state :draft, initial: true
    state :under_moderation
    state :published
    state :rejected
    state :archived

    event :to_moderate do
      transitions from: %i[draft rejected], to: :under_moderation
    end

    event :publish do
      transitions from: :under_moderation, to: :published
    end

    event :reject do
      transitions from: :under_moderation, to: :rejected
    end

    event :archive do
      transitions from: %i[draft under_moderation published rejected], to: :archived
    end

    event :unarchive do
      transitions from: :archived, to: :draft
    end
  end

  def self.ransackable_attributes(_ = nil)
    %w[id title state created_at category_id user_id]
  end

  def self.ransackable_associations(_ = nil)
    %w[user category]
  end

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
