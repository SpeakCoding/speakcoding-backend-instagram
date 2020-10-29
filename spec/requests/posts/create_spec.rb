require 'rails_helper'

RSpec.describe "PostsController", type: :request do
  it "should create post" do
    user = User.create(email: "alx.gsv@gmail.com", password: "123456")
    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body["data"]["description"]).to eq("a")
    expect(response.parsed_body["data"]["location"]).to eq("b")
  end

  it "shouldn't create post w/o image" do
    user = User.create(email: "alx.gsv@gmail.com", password: "123456")
    post "/posts.json", params: { post: { description: "a", location: "b" } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(422)
  end

  it "shouldn't create post w/o user" do
    user = User.create(email: "alx.gsv@gmail.com", password: "123456")
    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }
    expect(response.code.to_i).to eq(403)
    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }, headers: { "Authentication-Token": "123" }
    expect(response.code.to_i).to eq(403)
  end

  it "should update user's posts_count" do
    user = User.create(email: "alx.gsv@gmail.com", password: "123456")

    get "/users/#{user.id}.json"
    expect(response.parsed_body["data"]["posts_count"]).to eq(0)

    post "/posts.json", params: { post: { description: "a", location: "b", image: uri_scheme_encode_image("images/lenna.png") } }, headers: { "Authentication-Token": user.authentication_token }
    expect(response.code.to_i).to eq(200)

    get "/users/#{user.id}.json"
    expect(response.parsed_body["data"]["posts_count"]).to eq(1)
  end
end
