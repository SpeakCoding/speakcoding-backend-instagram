require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  it 'should index posts' do
    user = User.create(email: 'alx.gsv@gmail.com', password: '123456')
    Post.create(user: user, description: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))
    Post.create(user: user, description: 'c', location: 'd', image: fixture_file_upload('images/lenna.png', 'image/png'))
    get '/posts.json', headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(2)
  end
end
