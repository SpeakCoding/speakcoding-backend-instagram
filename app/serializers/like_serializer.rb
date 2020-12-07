class LikeSerializer < ApplicationSerializer
  def initialize(like, controller = nil)
    @like = like
    @controller = controller
  end

  def serialize
    {
      post: PostSerializer.new(@like.post, @controller).serialize,
      user: UserSerializer.new(@like.user, @controller).serialize,
      created_at: @like.created_at.to_i
    }
  end
end
