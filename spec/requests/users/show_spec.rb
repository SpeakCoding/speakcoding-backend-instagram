require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  it 'should show user' do
    user = User.create(
      email: 'a@b.c',
      full_name: 'Elena',
      portrait: fixture_file_upload('images/lenna.png', 'image/png'),
      bio: 'bio',
      password: '123456'
    )
    get "/users/#{user.id}.json"
    expect(response.code.to_i).to eq(200)
    expect(response.parsed_body['data']['email']).to eq('a@b.c')
    expect(response.parsed_body['data']['full_name']).to eq('Elena')
    expect(response.parsed_body['data']['bio']).to eq('bio')
  end
end
