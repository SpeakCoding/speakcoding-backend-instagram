class Service::UsersController < ApplicationController
  before_action :authenticate_service

  def show
    user = User.find(params[:id])
    render json: {
      data: UserSerializer.new(user, self).serialize,
      meta: { authentication_token: user.authentication_token }
    }
  end

  def create
    email = "service_user_#{SecureRandom.alphanumeric.downcase}@speakcoding.co"
    password = SecureRandom.alphanumeric(25)
    user = User.create!(
      email: email,
      password: password
    )
    # Followships with seed users
    User.where(seed: true).first(5).each do |seed_user|
      user.follow(seed_user)
      seed_user.follow(user)
    end
    render json: {
      data: UserSerializer.new(user, self).serialize,
      meta: {
        email: email,
        authentication_token: user.authentication_token
      }
    }
  end

  private

  def authenticate_service
    jwt = JWT.decode(params[:auth], ENV['SPEAKCODING_INSTAGRAM_SERVICE_SECRET_KEY'])
    return if 10.seconds.ago.to_i <= jwt[0]['now']

    render_unauthorized
  end
end
