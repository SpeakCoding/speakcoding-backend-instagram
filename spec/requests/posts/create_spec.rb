require 'rails_helper'

RSpec.describe "PostsController", type: :request do
  it "should create post" do
    user = User.create(email: "alx.gsv@gmail.com", password: SecureRandom.uuid)
    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body["data"]["description"]).to eq("a")
    expect(response.parsed_body["data"]["location"]).to eq("b")
  end

  it "shouldn't create post w/o image" do
    user = User.create(email: "alx.gsv@gmail.com", password: SecureRandom.uuid)
    post "/posts.json", params: { post: { description: "a", location: "b" } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(422)
  end

  it "shouldn't create post w/o user" do
    user = User.create(email: "alx.gsv@gmail.com", password: SecureRandom.uuid)
    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }
    expect(response.code.to_i).to eq(403)
    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }, headers: { "Authentication-Token": "123" }
    expect(response.code.to_i).to eq(403)
  end

  it "should update user's posts_count" do
    user = User.create(email: "alx.gsv@gmail.com", password: SecureRandom.uuid)

    get "/users/#{user.id}.json"
    expect(response.parsed_body["data"]["posts_count"]).to eq(0)

    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)

    get "/users/#{user.id}.json"
    expect(response.parsed_body["data"]["posts_count"]).to eq(1)
  end

  it "should create tags" do
    user1 = User.create(email: "a@gmail.com", password: SecureRandom.uuid)
    user2 = User.create(email: "b@gmail.com", password: SecureRandom.uuid)
    user3 = User.create(email: "c@gmail.com", password: SecureRandom.uuid)
    tags = [{user_id: user2.id, top: 0.12, left: 0.34}, {user_id: user3.id, top: 0.56, left: 0.78}]
    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png"), tags: tags } }, headers: { "Authentication-Token": user1.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body["data"]["tags"].size).to eq(2)
    expect(response.parsed_body["data"]["tags"].map{ |tag| tag["user"]["id"]}.sort).to eq([user2.id, user3.id].sort)
  end
end
