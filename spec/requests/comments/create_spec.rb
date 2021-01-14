require 'rails_helper'

RSpec.describe 'CommentsController', type: :request do
  it 'should create comments' do
    user = User.create(email: 'alx.gsv@gmail.com', password: '123456')
    post = Post.create(user: user, caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))

    get "/posts/#{post.id}.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['comments'].size).to eq(0)

    expect(Comment.count).to eq(0)

    post '/comments.json', params: { comment: { text: 'Test 1', post_id: post.id } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['text']).to eq('Test 1')
    expect(Comment.count).to eq(1)

    post '/comments.json', params: { comment: { text: 'Test 2', post_id: post.id } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['text']).to eq('Test 2')
    expect(Comment.count).to eq(2)

    get "/posts/#{post.id}.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['comments'].size).to eq(2)
    expect(response.parsed_body['data']['comments'][0]['text']).to eq('Test 1')
    expect(response.parsed_body['data']['comments'][1]['text']).to eq('Test 2')
  end
end
