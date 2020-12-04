require 'rails_helper'

RSpec.describe 'PostsController', type: :request do
  it 'should destroy post' do
    user1 = User.create(email: 'a@gmail.com', password: SecureRandom.uuid)
    post = user1.posts.create!({ caption: 'a', location: 'b', image: fixture_file_upload('images/lenna.png', 'image/png') })
    expect(Post.count).to eq(1)

    delete "/posts/#{post.id}.json", headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(Post.count).to eq(0)
  end
end
