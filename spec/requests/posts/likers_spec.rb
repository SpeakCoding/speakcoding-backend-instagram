require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  it 'should like and unlike posts' do
    user1 = User.create(email: 'alex@gmail.com', password: '123456')
    user2 = User.create(email: 'alexander@gmail.com', password: '123456')
    post = Post.create(user: user1, caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))
    Like.create!(post: post, user: user1, created_at: 1.day.ago)
    Like.create!(post: post, user: user2)

    get "/posts/#{post.id}/likers.json"
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(2)
    expect(response.parsed_body['data'][0]["id"]).to eq(user2.id)
    expect(response.parsed_body['data'][1]["id"]).to eq(user1.id)
  end
end
