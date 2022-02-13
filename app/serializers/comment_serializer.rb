class CommentSerializer < ApplicationSerializer
  def initialize(comment, controller = nil)
    @comment = comment
    @controller = controller
  end

  def serialize()
    return {
      id: @comment.id,
      user: UserSerializer.new(@comment.user, @controller).serialize(),
      text: @comment.text,
      reply_id: @comment.reply_id,
      replies: @comment.replies.sort_by(&:created_at).map{ |comment| CommentSerializer.new(comment, @controller).serialize() },
      created_at: @comment.created_at.to_i()
    }
  end
end
