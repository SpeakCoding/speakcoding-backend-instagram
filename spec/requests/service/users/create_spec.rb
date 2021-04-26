require 'rails_helper'

RSpec.describe 'Service::UsersController', type: :request do
  it 'should create user' do
    ENV['SPEAKCODING_INSTAGRAM_SERVICE_SECRET_KEY'] = 'abc'
    jwt = JWT.encode({ now: Time.now.to_i }, ENV['SPEAKCODING_INSTAGRAM_SERVICE_SECRET_KEY'])
    post '/service/users.json', params: { auth: jwt }
    expect(response.code.to_i).to eq(200)
    expect(User.count).to eq(1)
  end

  it 'shouldn\'t allow old tokens' do
    ENV['SPEAKCODING_INSTAGRAM_SERVICE_SECRET_KEY'] = 'abc'
    jwt = JWT.encode({ now: 11.seconds.ago.to_i }, ENV['SPEAKCODING_INSTAGRAM_SERVICE_SECRET_KEY'])
    post '/service/users.json', params: { auth: jwt }
    expect(response.code.to_i).not_to eq(200)
    expect(User.count).to eq(0)
  end
end
