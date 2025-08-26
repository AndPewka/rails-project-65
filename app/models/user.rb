# frozen_string_literal: true

class User < ApplicationRecord
  has_many :bulletins, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name,  presence: true

  def self.ransackable_attributes(_ = nil)
    %w[id name email admin created_at updated_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[bulletins]
  end
end
