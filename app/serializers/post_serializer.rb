class PostSerializer < ApplicationSerializer
  def initialize(post, controller = nil)
    @post = post
    @controller = controller
  end

  def serialize
    liker_followee = Like.find_by(post: @post, user: @controller&.current_user&.followees)&.user
    {
      id: @post.id,
      location: @post.location.presence,
      caption: @post.caption.presence,
      image: @controller&.url_for(@post.image.variant(resize_to_limit: [1080, 1080])),
      user: UserSerializer.new(@post.user, @controller).serialize,
      likes_count: @post.likes_count,
      liked: Like.find_by(post: @post, user: @controller.current_user).present?,
      liker_followee: UserSerializer.new(liker_followee, @controller).serialize,
      saved: PostSaved.find_by(post: @post, user: @controller.current_user).present?,
      created_at: @post.created_at.to_i,
      tags: @post.user_post_tags.map { |tag| UserPostTagSerializer.new(tag, @controller).serialize },
      comments: @post.comments.map{ |comment| CommentSerializer.new(comment, @controller).serialize }
    }
  end
end
