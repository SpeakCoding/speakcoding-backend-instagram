class Post < ApplicationRecord
  belongs_to(:user, counter_cache: true)
  has_many(:user_post_tags, dependent: :delete_all)
  has_many(:comments, -> { order(created_at: :asc) }, dependent: :destroy)
  has_many(:likes, dependent: :destroy)
  has_one_attached(:image)

  validate(:image_should_be_attached)

  private

  def image_should_be_attached()
    if !image.attached?
      errors.add(:image, "isn't attached")
    end
  end
end
