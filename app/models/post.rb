class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_one_attached :image

  validate :image_should_be_attached

  private

  def image_should_be_attached
    errors.add(:image, "isn't attached") if !image.attached?
  end
end
