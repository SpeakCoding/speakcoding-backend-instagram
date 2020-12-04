require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  it 'should index posts' do
    user = User.create(email: 'alx.gsv@gmail.com', password: '123456')
    post1 = Post.create(user: user, caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'), created_at: 2.days.ago)
    post2 = Post.create(user: user, caption: 'c', location: 'd', image: fixture_file_upload('images/lenna.png', 'image/png'), created_at: 1.days.ago)
    get '/posts.json', headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(2)
    expect(response.parsed_body['data'][0]['id']).to eq(post2.id)
  end
end
