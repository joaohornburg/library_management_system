# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Sessions', type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  describe 'POST /api/v1/users/sign_in' do
    let(:valid_params) { { user: { email: user.email, password: 'password' } } }
    let(:invalid_params) { { user: { email: user.email, password: 'wrongpassword' } } }
    context 'with valid credentials' do
      it 'returns a JWT token in the Authorization header' do
        expect(user.valid_password?('password')).to be_truthy
        post '/api/v1/users/sign_in', params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        token = response.headers['Authorization']
        expect(token).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'does not return a JWT token' do
        post '/api/v1/users/sign_in', params: invalid_params, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers['Authorization']).to be_nil
      end
    end
  end
end
