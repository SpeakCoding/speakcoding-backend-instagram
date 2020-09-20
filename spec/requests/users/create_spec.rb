require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should create user and return fresh authentication token' do
    post '/users.json', params: { user: { email: 'alx.gsv@gmail.com', password: '123456' } }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['email']).to eq('alx.gsv@gmail.com')
    expect(response.parsed_body['meta']['authentication_token']).to be_present
  end

  it 'shouldnt create users with same email' do
    post '/users.json', params: { user: { email: 'alx.gsv@gmail.com', password: '123456' } }
    post '/users.json', params: { user: { email: 'alx.gsv@Gmail.com', password: '1234567' } }
    expect(response.code.to_i).to eq(422)
    expect(response.parsed_body['errors'][0]['source']['parameter']).to eq('email')
  end

  it 'shouldnt create users without email' do
    post '/users.json', params: { user: { password: '123456' } }
    expect(response.code.to_i).to eq(422)
    expect(response.parsed_body['errors'][0]['source']['parameter']).to eq('email')
  end

  it 'shouldnt create users without password' do
    post '/users.json', params: { user: { email: 'alx.gsv@gmail.com' } }
    expect(response.code.to_i).to eq(422)
    expect(response.parsed_body['errors'][0]['source']['parameter']).to eq('password')
  end

  it 'shouldnt create users with bad email' do
    post '/users.json', params: { user: { email: 'alx.gsvgmail.com', password: '123456' } }
    expect(response.code.to_i).to eq(422)
    expect(response.parsed_body['errors'][0]['source']['parameter']).to eq('email')
  end
end
