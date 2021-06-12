class UserSerializer < ApplicationSerializer
  def initialize(user, controller = nil)
    @user = user
    @controller = controller
  end

  def serialize()
    if @user.nil?
      return nil
    end

    return {
      id: @user.id,
      email: @user.email,
      user_name: @user.user_name.presence(),
      bio: @user.bio.presence(),
      profile_picture: profile_picture_url(),
      posts_count: @user.posts_count,
      followers_count: @user.followers_count,
      followees_count: @user.followees_count,
      is_followee: @controller&.current_user&.follows?(@user),
      is_follower: @user.follows?(@controller&.current_user())
    }
  end

  def profile_picture_url()
    if !@user.profile_picture.attached? || !@controller
      return nil
    end

    return @controller.url_for(@user.profile_picture.variant(resize_to_limit: [1080, 1080]))
  end
end
