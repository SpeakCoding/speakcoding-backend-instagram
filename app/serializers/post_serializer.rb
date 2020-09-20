class PostSerializer < ApplicationSerializer
  def initialize(post, controller = nil)
    @post = post
    @controller = controller
  end

  def serialize
    {
      id: @post.id,
      location: @post.location.presence,
      description: @post.description.presence,
      image: @controller&.url_for(@post.image.variant(resize_to_limit: [1080, 1080])),
      user: UserSerializer.new(@post.user, @controller).serialize,
      created_at: @post.created_at.to_i
    }
  end
end
