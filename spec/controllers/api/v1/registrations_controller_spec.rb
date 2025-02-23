# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    request.headers['Accept'] = 'application/json'
    request.format = :json
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        user: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: '', # invalid email
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post :create, params: valid_attributes, format: :json
        end.to change(User, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes, format: :json
        expect(response).to have_http_status(:created)
      end

      it "returns the created user's attributes in JSON" do
        post :create, params: valid_attributes, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq('test@example.com')
        expect(json_response['role']).to eq('member')
        expect(json_response['id']).to be_present
      end

      context 'when user is trying to sign up as a librarian' do
        it 'creates a new User with member role' do
          # It would be insecure to allow anyone to register as a librarian.
          # TODO: create a way that a librarian (or even better, an admin) can promote a user to librarian.
          post :create,
               params: { user: { email: 'test@example.com', password: 'password', password_confirmation: 'password', role: 'librarian' } }, format: :json
          expect(User.last.member?).to be_truthy
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post :create, params: invalid_attributes, format: :json
        end.not_to change(User, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_attributes, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages in JSON' do
        post :create, params: invalid_attributes, format: :json
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to be_present
      end
    end
  end
end
