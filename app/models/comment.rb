class Comment < ApplicationRecord
  belongs_to(:post, counter_cache: true)
  belongs_to(:user)
  has_many(:replies, class_name: 'Comment', foreign_key: :reply_id, dependent: :destroy)

  validate(:should_not_allow_replies_to_replies)

  private

  def should_not_allow_replies_to_replies
    return if reply_id.blank?

    parent_comment = Comment.find_by(id: reply_id)
    return if parent_comment.blank?

    if parent_comment.reply_id.present?
      errors.add(:reply_id, "incorrect, because parent comment is a reply")
    end
  end
end
