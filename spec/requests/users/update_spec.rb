require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should update existing user' do
    user = User.create(
      email: 'a@b.c',
      user_name: 'Elena',
      password: '123456'
    )
    put "/users/#{user.id}.json", params: { user: { user_name: "Alex" }}, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['user_name']).to eq('Alex')
  end

  it 'shouldnt allow to update other users' do
    user1 = User.create(
      email: 'a1@b.c',
      user_name: 'Elena',
      password: '123456'
    )
    user2 = User.create(
      email: 'a2@b.c',
      password: '123456'
    )
    put "/users/#{user1.id}.json", params: { user: { user_name: "Alex" }}, headers: { "Authentication-Token": user2.authentication_token }
    expect(response.code.to_i).to eq(403)
  end
end
