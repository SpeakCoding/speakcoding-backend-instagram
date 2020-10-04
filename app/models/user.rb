class User < ApplicationRecord
  has_many :posts

  has_secure_password
  has_one_attached :portrait

  before_validation :downcase_email, :ensure_authentication_token

  validates :authentication_token, uniqueness: true, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /[^\s]@[^\s]/ }

  def regenerate_authentication_token
    self.authentication_token = SecureRandom.alphanumeric(50)
  end

  private

  def ensure_authentication_token
    regenerate_authentication_token if authentication_token.blank?
  end

  def downcase_email
    self.email&.downcase!
  end
end
