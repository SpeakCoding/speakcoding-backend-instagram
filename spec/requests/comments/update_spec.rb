require 'rails_helper'

RSpec.describe 'CommentsController', type: :request do
  it 'should update comments' do
    user = User.create(email: 'alx.gsv@gmail.com', password: '123456')
    post = Post.create(user: user, caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png'))
    comment = post.comments.create(user: user, text: 'Test 1')

    get "/posts/#{post.id}.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['comments'].size).to eq(1)

    expect(Comment.count).to eq(1)

    put "/comments/#{comment.id}.json", params: { comment: { text: 'Test 2' } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['text']).to eq('Test 2')
    expect(Comment.count).to eq(1)

    get "/posts/#{post.id}.json", headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['comments'].size).to eq(1)
    expect(response.parsed_body['data']['comments'][0]['text']).to eq('Test 2')
  end
end
