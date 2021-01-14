class User < ApplicationRecord
  has_many :posts
  has_many :followers_records, class_name: 'Followship', foreign_key: 'followee_id', dependent: :destroy
  has_many :following_records, class_name: 'Followship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followers, through: :followers_records, source: :follower
  has_many :followees, through: :following_records, source: :followee

  has_secure_password
  has_one_attached :profile_picture

  before_validation :downcase_email, :ensure_authentication_token

  validates :authentication_token, uniqueness: true, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /[^\s]@[^\s]/ }

  def can_follow?(other_user)
    other_user && other_user != self && !follows?(other_user)
  end

  def can_unfollow?(other_user)
    other_user && other_user != self && follows?(other_user)
  end

  def follows?(other_user)
    Followship.where(follower: self, followee: other_user).exists?
  end

  def follow(other_user)
    return unless can_follow?(other_user)

    followship = Followship.create!(follower: self, followee: other_user)
    User.where(id: other_user.id).update_all(followers_count: Followship.where(followee_id: other_user.id).count)
    User.where(id: id).update_all(followees_count: Followship.where(follower_id: id).count)
    followship
  end

  def unfollow(other_user)
    Followship.where(follower_id: id, followee_id: other_user.id).delete_all
    User.where(id: other_user.id).update_all(followers_count: Followship.where(followee_id: other_user.id).count)
    User.where(id: id).update_all(followees_count: Followship.where(follower_id: id).count)
  end

  def regenerate_authentication_token
    self.authentication_token = SecureRandom.alphanumeric(50)
  end

  private

  def ensure_authentication_token
    regenerate_authentication_token if authentication_token.blank?
  end

  def downcase_email
    email&.downcase!
  end
end
