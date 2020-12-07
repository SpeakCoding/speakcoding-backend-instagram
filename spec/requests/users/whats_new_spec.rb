require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  it 'should like and unlike posts' do
    user1 = User.create(email: 'alx.gsv@gmail.com', password: '123456')
    user2 = User.create(email: 'helen@gmail.com', password: '123456')
    post = Post.create(user: user1, caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))

    post "/posts/#{post.id}/like.json", headers: { "Authentication-Token": user2.authentication_token }
    expect(response.code.to_i).to eq(200)

    get "/users/#{user1.id}/whats_new.json", headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(1)
    expect(response.parsed_body['data'][0]['user']['id']).to eq(user2.id)
  end
end
