# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::DashboardsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:librarian) { User.create!(email: 'librarian@example.com', password: 'password', role: :librarian) }
  let(:member) { User.create!(email: 'member@example.com', password: 'password', role: :member) }
  let(:book) { Book.create!(title: 'Test Book', author: 'Test Author', isbn: '1234567890', total_copies: 1) }

  describe 'GET #show' do
    context 'when user is a librarian' do
      before { sign_in librarian }

      it 'returns librarian dashboard data' do
        get :show
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to include('total_books', 'total_borrowed_books', 'books_due_today',
                                              'overdue_borrowings')
      end
    end

    context 'when user is a member' do
      before { sign_in member }

      it 'returns member dashboard data' do
        get :show
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to include('current_borrowings', 'overdue_borrowings')
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get :show, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
