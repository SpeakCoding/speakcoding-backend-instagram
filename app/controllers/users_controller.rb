class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    if user.save
      render json: serialize_user(user)
    else
      render_errors(user.errors)
    end
  end

  def authenticate
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password]) 
      user.regenerate_authentication_token
      user.save!
      render json: serialize_user(user)
    else
      render json: { errors: [{source: { parameter: "password" }, detail: "doesn't match email"}] }, status: 403
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def serialize_user(user)
    { 
      data: { id: user.id, email: user.email },
      meta: { authentication_token: user.authentication_token }
    }
  end
end
