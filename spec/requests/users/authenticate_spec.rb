require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should authentucate user and return authentication token' do
    user = User.create!(email: 'alx.gsv@gmail.com', password: '123456')
    old_authentication_token = user.authentication_token
    post '/users/authenticate.json', params: { user: { email: 'alx.gsv@gmail.com', password: '123456' } }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['email']).to eq('alx.gsv@gmail.com')
    expect(response.parsed_body['meta']['authentication_token']).to be_present
    expect(response.parsed_body['meta']['authentication_token']).to eq(old_authentication_token)
  end

  it "shouldn't authenticate when email doesn't exist" do
    post '/users/authenticate.json', params: { user: { email: 'alx.gsv@gmail.com', password: '123456' } }
    expect(response.code.to_i).to eq(403)
  end

  it "shouldn't authenticate when password is wrong" do
    post '/users/authenticate.json', params: { user: { email: 'alx.gsv@gmail.com', password: '17' } }
    expect(response.code.to_i).to eq(403)
  end
end
