class UsersController < ApplicationController
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

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name, :bio, :portrait)
  end
end
