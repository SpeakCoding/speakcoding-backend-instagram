require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should search users' do
    User.create!(user_name: 'Elena', email: 'a1@b.c', password: '123456')
    User.create!(user_name: 'Emma', email: 'a2@b.c', password: '123456')

    get '/users/search.json', params: { query: 'e' }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(2)

    get '/users/search.json', params: { query: 'el' }
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data'].size).to eq(1)
    expect(response.parsed_body['data'][0]['user_name']).to eq('Elena')
  end
end
