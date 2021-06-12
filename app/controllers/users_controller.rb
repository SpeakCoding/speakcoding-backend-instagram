class UsersController < ApplicationController
  before_action :require_current_user, only: %i[follow unfollow forget]

  def show()
    if params[:id] == 'me'
      if !current_user()
        raise ActiveRecord::RecordNotFound
      end

      user = current_user()
    else
      user = User.find(params[:id])
    end
    render(json: {
      data: UserSerializer.new(user, self).serialize()
    })
  end

  def create()
    user = User.create(user_params())
    if user.save()
      # Followships with seed users
      User.where(seed: true).first(5).each do |seed_user|
        user.follow(seed_user)
        seed_user.follow(user)
      end
      render(json: {
        data: UserSerializer.new(user, self).serialize(),
        meta: { authentication_token: user.authentication_token }
      })
    else
      render_errors(user.errors())
    end
  end

  def update()
    user = User.find(params[:id])

    if user != current_user()
      render_unauthorized
      return
    end

    user.attributes = user_params()
    if user.save()
      render(json: {
        data: UserSerializer.new(user, self).serialize()
      })
    else
      render_errors(user.errors())
    end
  end

  def authenticate()
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      render json: {
        data: UserSerializer.new(user, self).serialize(),
        meta: { authentication_token: user.authentication_token }
      }
    else
      render(json: { errors: [{ source: { parameter: 'password' }, detail: "doesn't match email" }] }, status: 403)
    end
  end

  def forget()
    current_user().update(authentication_token: nil)
    render(json: {
      data: {}
    })
  end

  def posts()
    user = User.find(params[:id])
    posts = user.posts.order('id desc')
    render(json: {
      data: posts.map { |post| PostSerializer.new(post, self).serialize() }
    })
  end

  def follow()
    other_user = User.find(params[:id])
    current_user().follow(other_user)

    render(json: {
      data: UserSerializer.new(other_user.reload(), self).serialize()
    })
  end

  def unfollow()
    other_user = User.find(params[:id])
    current_user().unfollow(other_user)

    render(json: {
      data: UserSerializer.new(other_user.reload(), self).serialize()
    })
  end

  def followers()
    user = User.find(params[:id])

    render(json: {
      data: user.followers().map { |follower| UserSerializer.new(follower, self).serialize() }
    })
  end

  def followees()
    user = User.find(params[:id])

    render(json: {
      data: user.followees().map { |followee| UserSerializer.new(followee, self).serialize() }
    })
  end

  def search()
    users = User.where('user_name LIKE ?', params[:query] + '%').limit(10)
    render(json: {
      data: users.map { |user| UserSerializer.new(user, self).serialize() }
    })
  end

  def whats_new()
    user = User.find(params[:id])

    @likes = Like.joins(:post).where(posts: { user_id: user.id }).order('posts.created_at desc')

    render(json: {
      data: @likes.map { |like| LikeSerializer.new(like, self).serialize() }
    })
  end

  private

  def user_params()
    result = params.require(:user).permit(:email, :password, :user_name, :bio, :profile_picture)

    if result[:profile_picture].present?()
      tempfile = Tempfile.new('image.jpg')
      tempfile.write(URI::Data.new(result[:profile_picture]).data.force_encoding('UTF-8'))
      tempfile.close()
      result[:profile_picture] = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: SecureRandom.alphanumeric(10) + '.jpg')
    end

    return result
  end
end
