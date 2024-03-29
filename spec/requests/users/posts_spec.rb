require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should show user' do
    user1 = User.create(
      email: 'a@b.c',
      user_name: 'Elena',
      profile_picture: fixture_file_upload('images/lenna.png', 'image/png'),
      bio: 'bio',
      password: '123456'
    )
    post1 = Post.create(user: user1, caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))
    user2 = User.create(
      email: 'd@e.f',
      user_name: 'Anna',
      profile_picture: fixture_file_upload('images/lenna.png', 'image/png'),
      bio: 'bio',
      password: '654321'
    )
    get "/users/#{user2.id}/posts.json"
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(0)

    post2 = Post.create(user: user2, caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))
    get "/users/#{user2.id}/posts.json"
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(1)
    expect(response.parsed_body['data'][0]['id']).to eq(post2.id)
  end
end
