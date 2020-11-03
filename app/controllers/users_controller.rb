class UsersController < ApplicationController
  before_action :require_current_user, only: [:follow, :unfollow]

  def show
    user = User.find(params[:id])
    render json: {
      data: UserSerializer.new(user, self).serialize
    }
  end

  def create
    user = User.create(user_params)
    if user.save
      render json: {
        data: UserSerializer.new(user, self).serialize,
        meta: { authentication_token: user.authentication_token }
      }
    else
      render_errors(user.errors)
    end
  end

  def update
    user = User.find(params[:id])

    render_unauthorized and return if !current_user || user != current_user

    user.attributes = user_params
    if user.save
      render json: {
        data: UserSerializer.new(user, self).serialize
      }
    else
      render_errors(user.errors)
    end
  end

  def authenticate
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      user.regenerate_authentication_token
      user.save!
      render json: {
        data: UserSerializer.new(user, self).serialize,
        meta: { authentication_token: user.authentication_token }
      }
    else
      render json: { errors: [{ source: { parameter: 'password' }, detail: "doesn't match email" }] }, status: 403
    end
  end

  def posts
    user = User.find(params[:id])
    posts = user.posts.order('id desc')
    render json: {
      data: posts.map { |post| PostSerializer.new(post, self).serialize }
    }
  end

  def follow
    other_user = User.find(params[:id])
    current_user.follow(other_user)

    render json: {
      data: UserSerializer.new(other_user.reload, self).serialize
    }
  end

  def unfollow
    other_user = User.find(params[:id])
    current_user.unfollow(other_user)

    render json: {
      data: UserSerializer.new(other_user.reload, self).serialize
    }
  end

  def followers
    user = User.find(params[:id])

    render json: {
      data: user.followers.map { |follower| UserSerializer.new(follower, self).serialize }
    }
  end

  def followees
    user = User.find(params[:id])

    render json: {
      data: user.followees.map { |followee| UserSerializer.new(followee, self).serialize }
    }
  end

  private

  def user_params
    result = params.require(:user).permit(:email, :password, :full_name, :bio, :portrait)

    if result[:portrait].present?
      tempfile = Tempfile.new('image.jpg')
      tempfile.write(URI::Data.new(result[:portrait]).data.force_encoding('UTF-8'))
      tempfile.close
      result[:portrait] = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: SecureRandom.alphanumeric(10) + '.jpg')
    end

    result
  end
end
