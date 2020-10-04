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
      posts_count: @user.posts_count
    }
  end

  def portrait_url
    return nil if !@user.portrait.attached?
    return nil if !@controller

    @controller.url_for(@user.portrait.variant(resize_to_limit: [1080, 1080]))
  end
end
