class UserPostTagSerializer < ApplicationSerializer
  def initialize(tag, controller = nil)
    @tag = tag
    @controller = controller
  end

  def serialize
    {
      user: UserSerializer.new(@tag.user).serialize,
      left: @tag.left,
      top: @tag.top
    }
  end
end
