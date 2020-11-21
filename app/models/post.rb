class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :user_post_tags, dependent: :delete_all
  has_many :comments, -> { order(created_at: :asc) }
  has_one_attached :image

  validate :image_should_be_attached

  private

  def image_should_be_attached
    errors.add(:image, "isn't attached") unless image.attached?
  end
end
