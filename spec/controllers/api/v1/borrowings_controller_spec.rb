# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BorrowingsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:librarian) { User.create!(email: 'librarian@example.com', password: 'password', role: :librarian) }
  let(:member) { User.create!(email: 'member@example.com', password: 'password', role: :member) }
  let(:book) { Book.create!(title: 'Test Book', author: 'Test Author', isbn: '1234567890', total_copies: 1) }

  describe 'POST #create' do
    context 'when user is a member' do
      before { sign_in member }

      it 'creates a new borrowing' do
        expect do
          post :create, params: { book_id: book.id }, format: :json
        end.to change(Borrowing, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      context 'when book is not available' do
        before do
          other_user = User.create!(email: 'other@example.com', password: 'password', role: :member)
          Borrowing.create!(
            user: other_user,
            book:,
            borrowed_at: Time.current,
            due_date: 2.weeks.from_now
          )
        end

        it 'returns unprocessable entity' do
          post :create, params: { book_id: book.id }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors']).to include('Book is not available for borrowing')
        end
      end
    end

    context 'when user is a librarian' do
      before { sign_in librarian }

      it 'returns unauthorized' do
        post :create, params: { book_id: book.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        post :create, params: { book_id: book.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #return' do
    let!(:borrowing) do
      Borrowing.create!(
        user: member,
        book:,
        borrowed_at: Time.current,
        due_date: 2.weeks.from_now
      )
    end

    context 'when user is a librarian' do
      before { sign_in librarian }

      it 'marks the borrowing as returned' do
        patch :return, params: { id: borrowing.id }, format: :json
        expect(response).to have_http_status(:ok)
        expect(borrowing.reload.returned_at).to be_present
      end
    end

    context 'when user is a member' do
      before { sign_in member }

      it 'returns unauthorized' do
        patch :return, params: { id: borrowing.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        patch :return, params: { id: borrowing.id }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
    let!(:borrowing) do
      Borrowing.create!(
        user: member,
        book: book,
        borrowed_at: Time.current,
        due_date: 2.weeks.from_now
      )
    end

    context 'when user is a librarian' do
      before { sign_in librarian }

      it 'returns all borrowings grouped by user' do
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key(member.email)
        expect(json_response[member.email].first).to include(
          'book_title' => book.title,
          'user_email' => member.email
        )
      end
    end

    context 'when user is a member' do
      before { sign_in member }

      it 'returns only their borrowings' do
        other_book = Book.create!(
          title: 'Other Book',
          author: 'Other Author',
          isbn: '0987654321',
          total_copies: 1
        )
        
        other_user = User.create!(email: 'other@example.com', password: 'password', role: :member)
        other_borrowing = Borrowing.create!(
          user: other_user,
          book: other_book,
          borrowed_at: Time.current,
          due_date: 2.weeks.from_now
        )

        get :index, format: :json
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['book_title']).to eq(book.title)
      end
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
