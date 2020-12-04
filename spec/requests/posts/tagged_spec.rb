require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  it 'should list tagged posts' do
    user1 = User.create(email: 'a@gmail.com', password: SecureRandom.uuid)
    user2 = User.create(email: 'b@gmail.com', password: SecureRandom.uuid)

    get '/posts/tagged.json', params: { user_id: user2.id }, headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(0)

    tags = [{ user_id: user2.id, top: 0.12, left: 0.34 }]
    post '/posts.json', params: { post: { caption: 'a', location: 'b', image: uri_scheme_encode_image('images/lenna.png'), tags: tags } }, headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)

    get '/posts/tagged.json', params: { user_id: user2.id }, headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(1)
  end
end
