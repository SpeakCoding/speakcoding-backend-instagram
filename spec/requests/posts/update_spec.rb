require 'rails_helper'

RSpec.describe "PostsController", type: :request do
  it "should update post" do
    user1 = User.create(email: "a@gmail.com", password: SecureRandom.uuid)
    user2 = User.create(email: "b@gmail.com", password: SecureRandom.uuid)
    user3 = User.create(email: "c@gmail.com", password: SecureRandom.uuid)
    post = user1.posts.create!({ description: "a", location: "b", image: fixture_file_upload("images/lenna.png", "image/png") })
    post.user_post_tags = [UserPostTag.create!(post: post, user: user1, top: 0.12, left: 0.34)]

    new_tags = [{user_id: user2.id, top: 0.12, left: 0.34}, {user_id: user3.id, top: 0.56, left: 0.78}]
    put "/posts/#{post.id}.json", params: { post: { description: "c", tags: new_tags } }, headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body["data"]["description"]).to eq("c")
    expect(UserPostTag.count).to eq(2)
    expect(UserPostTag.all.to_a.map(&:user_id).sort).to eq([user2.id, user3.id].sort)
  end
end
