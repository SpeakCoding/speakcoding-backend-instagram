require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  it 'should index posts' do
    user = User.create(email: 'alx.gsv@gmail.com', password: '123456')
    post = Post.create(user: user, description: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))

    get "/posts/#{post.id}.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['likes_count']).to eq(0)
    expect(response.parsed_body['data']['liked']).to eq(false)

    post "/posts/#{post.id}/like.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['likes_count']).to eq(1)
    expect(response.parsed_body['data']['liked']).to eq(true)

    get "/posts/#{post.id}.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['likes_count']).to eq(1)
    expect(response.parsed_body['data']['liked']).to eq(true)

    post "/posts/#{post.id}/unlike.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['likes_count']).to eq(0)
    expect(response.parsed_body['data']['liked']).to eq(false)

    get "/posts/#{post.id}.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['likes_count']).to eq(0)
    expect(response.parsed_body['data']['liked']).to eq(false)
  end
end
