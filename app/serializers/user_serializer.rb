class UserSerializer < ApplicationSerializer
  def initialize(user, controller = nil)
    @user = user
    @controller = controller
  end

  def serialize
    return nil if @user.nil?

    {
      id: @user.id,
      email: @user.email,
      full_name: @user.full_name.presence,
      bio: @user.bio.presence,
      portrait: portrait_url,
      posts_count: @user.posts_count,
      followers_count: @user.followers_count,
      followees_count: @user.followers_count,
      is_followee: @controller&.current_user&.follows?(@user),
      is_follower: @user.follows?(@controller&.current_user)
    }
  end

  def portrait_url
    return nil unless @user.portrait.attached?
    return nil unless @controller

    @controller.url_for(@user.portrait.variant(resize_to_limit: [1080, 1080]))
  end
end
