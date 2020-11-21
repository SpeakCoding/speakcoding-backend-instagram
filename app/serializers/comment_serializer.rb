class CommentSerializer < ApplicationSerializer
  def initialize(comment, controller = nil)
    @comment = comment
    @controller = controller
  end

  def serialize
    {
      id: @comment.id,
      user: UserSerializer.new(@comment.user, @controller).serialize,
      body: @comment.body,
      created_at: @comment.created_at.to_i
    }
  end
end
