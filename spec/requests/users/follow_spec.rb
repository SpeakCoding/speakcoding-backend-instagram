require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should follow and unfollow user' do
    user0 = User.create(
      email: 'a@b.c',
      full_name: 'Elena',
      password: '123456'
    )

    user1 = User.create(
      email: 'd@e.f',
      full_name: 'Alex',
      password: '789012'
    )

    get "/users/#{user1.id}.json", headers: { "Authentication-Token": user0.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['is_followee']).to eq(false)
    expect(response.parsed_body['data']['is_follower']).to eq(false)
    expect(response.parsed_body['data']['followers_count']).to eq(0)
    expect(response.parsed_body['data']['followees_count']).to eq(0)

    post "/users/#{user1.id}/follow.json", headers: { "Authentication-Token": user0.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['is_followee']).to eq(true)
    expect(response.parsed_body['data']['is_follower']).to eq(false)
    expect(response.parsed_body['data']['followers_count']).to eq(1)
    expect(response.parsed_body['data']['followees_count']).to eq(0)

    post "/users/#{user0.id}/follow.json", headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['is_followee']).to eq(true)
    expect(response.parsed_body['data']['is_follower']).to eq(true)
    expect(response.parsed_body['data']['followers_count']).to eq(1)
    expect(response.parsed_body['data']['followees_count']).to eq(1)

    post "/users/#{user1.id}/unfollow.json", headers: { "Authentication-Token": user0.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['is_followee']).to eq(false)
    expect(response.parsed_body['data']['is_follower']).to eq(true)
    expect(response.parsed_body['data']['followers_count']).to eq(0)
    expect(response.parsed_body['data']['followees_count']).to eq(1)
  end
end
