require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should authentucate user and return fresh authentication token' do
    user = User.create!(email: 'alx.gsv@gmail.com', password: '123456')
    old_authentication_token = user.authentication_token
    post '/users/forget.json', headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(user.reload.authentication_token).not_to eq(old_authentication_token)
  end
end
