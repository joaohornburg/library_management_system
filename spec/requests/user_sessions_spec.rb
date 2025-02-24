# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Sessions', type: :request do
  let!(:user) { User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password') }
  let(:valid_params) { { user: { email: user.email, password: 'password' } } }
  let(:invalid_params) { { user: { email: user.email, password: 'wrongpassword' } } }

  describe 'POST /users/sign_in' do
    context 'with valid credentials' do
      it 'returns a JWT token in the Authorization header' do
        expect(user.valid_password?('password')).to be_truthy
        post '/users/sign_in', params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        token = response.headers['Authorization']
        expect(token).to be_present
      end

      it 'returns the user attributes in JSON' do
        post '/users/sign_in', params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq(user.email)
        expect(json_response['role']).to eq(user.role)
        expect(json_response['id']).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      it 'does not return a JWT token' do
        post '/users/sign_in', params: invalid_params, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.headers['Authorization']).to be_nil
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    it 'revokes the JWT token' do
      post '/users/sign_in', params: valid_params, as: :json
      token = response.headers['Authorization']
      
      delete '/users/sign_out', headers: { 'Authorization' => token }, as: :json
      expect(response).to have_http_status(:ok)

      get '/api/v1/dashboard', headers: { 'Authorization' => token }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
