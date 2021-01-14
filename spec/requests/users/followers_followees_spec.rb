require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should follow and unfollow user' do
    user0 = User.create(
      email: 'a@b.c',
      user_name: 'Elena',
      password: '123456'
    )

    user1 = User.create(
      email: 'd@e.f',
      user_name: 'Alex',
      password: '789012'
    )

    user2 = User.create(
      email: 'g@h.i',
      user_name: 'Alice',
      password: '345678'
    )

    user0.follow(user1)
    user0.follow(user2)
    user1.follow(user0)

    get "/users/#{user0.id}/followers.json", headers: { "Authentication-Token": user0.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(1)
    expect(response.parsed_body['data'][0]['id']).to eq(user1.id)

    get "/users/#{user0.id}/followees.json", headers: { "Authentication-Token": user0.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(2)
    expect(response.parsed_body['data'].map{ |x| x['id'] }.sort).to eq([user1.id, user2.id].sort)
  end
end
